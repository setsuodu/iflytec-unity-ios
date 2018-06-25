using System;
using System.Runtime.InteropServices;

public class Bridge
{
    // 语音合成

	[DllImport("__Internal")]
	public static extern void initSynthesizer();

	[DllImport("__Internal")]
	public static extern void startTTS(string content);

    [DllImport("__Internal")]
	public static extern void pauseTTS();

    [DllImport("__Internal")]
	public static extern void resumeTTS();

    [DllImport("__Internal")]
    public static extern void stopTTS();

	// 语音识别

    [DllImport("__Internal")]
	public static extern void initRecognizer();

    [DllImport("__Internal")]
    public static extern void startISR();

    [DllImport("__Internal")]
	public static extern void stopISR();

    //[DllImport("__Internal")]
    //public static extern void cancelISR();
}
