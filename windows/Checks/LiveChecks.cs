using ImperialSchool.Views.Core;
using System.Text;
using System.Text.Json.Nodes;

// Explicit development command, separate from building or running the application.
static class LiveChecks
{
    // Windows' decoder is not available in this portable test process.
    // Header validation below checks the managed streaming/import boundary only.
    static void Header(string path, int? expectedWidth, int? expectedHeight)
    {
        using var stream = File.OpenRead(path);
        if (stream.ReadByte() != 255 || stream.ReadByte() != 216) throw new InvalidDataException("Not JPEG");
        int Read16() { var a = stream.ReadByte(); var b = stream.ReadByte(); if (a < 0 || b < 0) throw new EndOfStreamException(); return a * 256 + b; }
        while (stream.Position < stream.Length)
        {
            if (stream.ReadByte() != 255) continue; int marker; do { marker = stream.ReadByte(); } while (marker == 255);
            if (marker is 216 or >= 208 and <= 215) continue;
            var length = Read16(); if (length < 2 || stream.Position + length - 2 > stream.Length) throw new InvalidDataException("JPEG marker");
            if (marker is 192 or 193 or 194 or 195 or 197 or 198 or 199 or 201 or 202 or 203 or 205 or 206 or 207)
            {
                stream.ReadByte(); var height = Read16(); var width = Read16();
                if (width != expectedWidth || height != expectedHeight) throw new InvalidDataException("JPEG dimensions"); return;
            }
            stream.Position += length - 2;
        }
        throw new InvalidDataException("JPEG has no dimensions");
    }
    public static async Task<int> Run(string[] args)
    {
        var work = Path.Combine(Path.GetTempPath(), "views-live-" + Guid.NewGuid().ToString("N")); Directory.CreateDirectory(work);
        try
        {
            using var assets = new AssetStore(work, Header); var json = Encoding.UTF8.GetString(await assets.Get("manifest-v3.json", 5_000_000, default));
            var data = Catalogue.Parse(json); var collection = data.Collections.First(c => c.Weather is not null && Weather.Text(c.Weather,"type")=="weather").Weather!; var format = Weather.Format(collection, "auto", 1920, 1080).Id;
            var sessions = new WeatherSessions(work, assets); int count = 1;
            Console.WriteLine("LIVE catalogue accepted; desktop format: " + format);
            foreach (var source in collection["sources"]!.AsArray())
            {
                var id = Weather.Text(source, "id"); var session = await sessions.Get(collection, id, format, true, default);
                if (session.Frame.Status != "ready") throw new InvalidDataException("Live forecast: " + id + " " + session.Frame.Status + " " + session.Warning);
                await assets.Picture(session.Frame.File!, default); count++;
                Console.WriteLine("LIVE current JPEG downloaded and verified: " + id + " " + session.Frame.StateId + "; next " + session.Frame.Next.ToString("O"));
            }
            var position = Array.IndexOf(args, "--archive");
            if (position >= 0)
            {
                var path = args[position + 1]; var descriptor = Weather.Descriptor(data, collection, format);
                assets.ImportWeatherZip(path, collection, format, descriptor, p => { if (p.Completed % 50 == 0) Console.WriteLine("LIVE ZIP " + p.Completed + "/" + p.Count); }, default);
                count++; Console.WriteLine("LIVE complete desktop ZIP imported: " + descriptor.Bytes + " bytes, " + descriptor.Version);
            }
            return count;
        }
        finally { if (Directory.Exists(work)) Directory.Delete(work, true); }
    }
}
