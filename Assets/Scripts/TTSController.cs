using System.IO;
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
        Bridge.initSynthesizer();

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
        //string path = Application.persistentDataPath + "/uri.pcm";
        string path = Application.persistentDataPath + "/baidu.wav";
        Bridge.startUriTTS(content, path);
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

    void SelectVoicer(bool value, int index)
    {
        if (value)
        {
            string _name = toggles[index].name;
            //Debug.Log(_name);
            Bridge.selectVoicer(_name);
        }
    }

    public void show(string log)
	{
		// 处理UnitySendMessage()回调
		Debug.Log("show ==>> " + log);
	}

    // 合成后回调，通知unity播放wav
    public void OnComplete(string path)
    {
        Debug.Log("saved in : " + path);
        StartCoroutine(LoadFile());
    }

    IEnumerator LoadFile()
    {
        string uripath = Application.persistentDataPath + "/uri.pcm";
        Debug.Log("uri is " + File.Exists(uripath));

        string filepath = Application.persistentDataPath + "/baidu.wav";
        Debug.Log("wav is " + File.Exists(filepath));

        FileInfo fi = new FileInfo(filepath);
        Debug.Log("文件大小 ==>> " + fi.Length);

        if (!File.Exists(filepath))
        {
            Debug.Log("下载失败");
            yield break;
        }

        // 读取本地要加"file://", 不然自动认为是网络请求
        WWW www = new WWW("file://" + filepath);
        yield return www;
        if(!string.IsNullOrEmpty(www.error))
        {
            Debug.Log("error while load: " + www.error);
        }

        yield return new WaitUntil(() => www.isDone);
        Debug.Log("加载成功:" + www.bytes.Length);

        AudioSource audioSource =  GetComponent<AudioSource>();
        //audioSource.clip = www.GetAudioClip(false, false, AudioType.MPEG);
        audioSource.clip = www.GetAudioClip();
        audioSource.Play();
    }
}
