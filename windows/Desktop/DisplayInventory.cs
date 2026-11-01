using System.Runtime.InteropServices;
using ImperialSchool.Views.Core;

namespace ImperialSchool.Views;

internal static class DisplayInventory
{
    [DllImport("user32.dll", EntryPoint = "EnumDisplayDevicesW", CharSet = CharSet.Unicode, ExactSpelling = true)]
    [return: MarshalAs(UnmanagedType.Bool)]
    static extern bool EnumDisplayDevices(string deviceName, uint index, ref DisplayDevice device, uint flags);

    public static Dictionary<string, Screen> ByInterfacePath()
    {
        var displays = new Dictionary<string, Screen>(StringComparer.OrdinalIgnoreCase);
        foreach (var screen in Screen.AllScreens)
            for (uint index = 0; ; index++)
            {
                var device = DisplayDevice.Create();
                if (!EnumDisplayDevices(screen.DeviceName, index, ref device, 1)) break; // EDD_GET_DEVICE_INTERFACE_NAME
                if ((device.StateFlags & 1) != 0 && !string.IsNullOrEmpty(device.DeviceId)) displays[device.DeviceId] = screen;
            }
        return displays;
    }
}
