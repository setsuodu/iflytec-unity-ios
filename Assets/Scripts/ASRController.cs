using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class ASRController : MonoBehaviour 
{
	public Text resultText;
   
    public void BackButton()
    {
		SceneManager.LoadScene("tts");
    }

	public void InitRecognizer()
    {
		Bridge.initRecognizer();
    }

    // 开始录音
	public void StartISR()
    {
        Bridge.startISR();
    }

    // 结束，显示识别结果
    public void StopISR()
    {
		Bridge.stopISR();
    }

	// 取消，没有识别结果
    public void CancelISR()
    {
		//Bridge.cancelISR();
    }
   
	public void isrResult(string log)
	{
		// 处理UnitySendMessage()回调
		Debug.Log("result ==>> " + log);

		resultText.text = log;
	}
}
