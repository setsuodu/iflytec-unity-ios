using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class TTSController : MonoBehaviour 
{
	public InputField contentField;
   
    public void BackButton()
    {
		SceneManager.LoadScene("asr");
    }

	public void InitSynthesizer()
	{      
		Bridge.initSynthesizer();
	}

	public void StartTTS ()
	{
		string content = contentField.text;
		Bridge.startTTS(content);
	}

    public void PauseTTS()
    {
		Bridge.pauseTTS();
	}

    public void ResumeTTS()
    {
		Bridge.resumeTTS();
    }

    public void StopTTS()
    {
		Bridge.stopTTS();
    }

	public void show(string log)
	{
		// 处理UnitySendMessage()回调
		Debug.Log("show ==>> " + log);
	}
}
