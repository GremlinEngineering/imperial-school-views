using System.Runtime.InteropServices;

namespace ImperialSchool.Views.Core;

// DISPLAY_DEVICEW from wingdi.h. Unicode fixed buffers are part of the ABI.
[StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
public struct DisplayDevice
{
    public uint Size;
    [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)] public string DeviceName;
    [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 128)] public string DeviceString;
    public uint StateFlags;
    [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 128)] public string DeviceId;
    [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 128)] public string DeviceKey;
    public static DisplayDevice Create() => new()
    {
        Size = (uint)Marshal.SizeOf<DisplayDevice>(), DeviceName = "", DeviceString = "", DeviceId = "", DeviceKey = ""
    };
}
