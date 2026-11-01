namespace ImperialSchool.Views.Core;

public sealed class NativeOperationException : Exception
{
    public string Operation { get; }
    public NativeOperationException(string operation, Exception error) : base(Describe(operation, error), error)
    { Operation = operation; HResult = error.HResult; }

    public static string Describe(string operation, Exception error)
    {
        var code = unchecked((uint)error.HResult).ToString("X8");
        // Only E_ACCESSDENIED establishes an access denial. Other COM failures remain distinct.
        var detail = error.HResult == unchecked((int)0x80070005) ? "Windows отказала в доступе." : "Ошибка компонента Windows.";
        return $"Не удалось {operation}. {detail} Код: 0x{code}.";
    }
}
