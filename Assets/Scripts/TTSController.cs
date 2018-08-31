using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class TTSController : MonoBehaviour 
{
	public InputField contentField;
	public Toggle[] toggles;

	void Start()
	{
        //Bridge.initSynthesizer();
		IFlyTekInterface.Initialize();

		for (int i = 0; i < toggles.Length; i++)
		{
			int index = i;
			toggles[i].onValueChanged.AddListener((bool value) => SelectVoicer(value, index));
		}
	}

	public void BackButton()
    {
		SceneManager.LoadScene("asr");
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

	void SelectVoicer(bool value, int index)
	{
		if (value)
		{
			string _name = toggles[index].name;
			//Debug.Log(_name);
			Bridge.selectVoicer(_name);
		}
	}
}
