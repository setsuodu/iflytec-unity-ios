using System;
using System.Text;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Security.Cryptography;

[RequireComponent(typeof(AudioSource))]
public class WebAPI : MonoBehaviour
{
    IEnumerator Start()
    {
        string url = "http://api.xfyun.cn/v1/service/v1/tts";

        Parameter parameter = new Parameter();
        string json_str = JsonUtility.ToJson(parameter);
        string base64_str = Convert.ToBase64String(Encoding.UTF8.GetBytes(json_str));
        byte[] data = Encoding.UTF8.GetBytes("text=这是中国，那里也是中国。"); //更改生成内容时，text= 要保留

        // 设置一些必要参数及请求头部：
        string t_s_1970 = TimestampSince1970;
        string checksum = GetMD5("361ce52dda2b82202328ce0c1a799774" + t_s_1970 + base64_str); //appkey
        
        Dictionary<string, string> header = new Dictionary<string, string>();
        header.Add("Content-Type", "application/x-www-form-urlencoded");
        header.Add("X-Param", base64_str);
        header.Add("X-CurTime", t_s_1970);
        header.Add("X-Appid", "5b8a15e6"); //appid
        header.Add("X-CheckSum", checksum);
        header.Add("X-Real-Ip", "127.0.0.1"); //在控制台设置白名单
        header.Add("charset", "utf-8");
        WWW www = new WWW(url, data, header);
        yield return www;
        if (!string.IsNullOrEmpty(www.error))
        {
            Debug.Log(www.error);
        }

        if (www.isDone)
        {
            //Streaming of '' on this platform is not supported
            //Unable to determine the audio type from the URL (http://api.xfyun.cn/v1/service/v1/tts) . Please specify the type.
            AudioClip clip = www.GetAudioClip(false, false, AudioType.WAV); //Windows
            GetComponent<AudioSource>().PlayOneShot(clip);
        }
    }

    public static string TimestampSince1970
    {
        get
        {
            return Convert.ToInt64((DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0, 0)).TotalSeconds).ToString();
        }
    }

    public static string GetMD5(string source, bool need16 = false, bool toUpper = false)
    {
        var t_toUpper = toUpper ? "X2" : "x2";
        if (string.IsNullOrEmpty(source))
        {
            return string.Empty;
        }
        string t_md5_code = string.Empty;
        try
        {
            MD5 t_md5 = MD5.Create();
            byte[] _t = t_md5.ComputeHash(Encoding.UTF8.GetBytes(source));
            for (int i = 0; i < _t.Length; i++)
            {
                t_md5_code += _t[i].ToString(t_toUpper);
            }
            if (need16)
            {
                t_md5_code = t_md5_code.Substring(8, 16);
            }
        }
        catch { }
        return t_md5_code;
    }
}

public class Parameter
{
    public string auf { get { return "audio/L16;rate=16000"; } set { } }
    public string aue { get { return "lame"; } set { } }
    public string voice_name { get { return "xiaoyan"; } set { } }
    public string speed { get { return "50"; } set { } }
    public string volume { get { return "50"; } set { } }
    public string pitch { get { return "50"; } set { } }
    public string engine_type { get { return "intp65"; } set { } }
    public string text_type { get { return "text"; } set { } }
}
