using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IFlyTekInterface
{
	public static void Initialize()
	{
		if(Application.platform == RuntimePlatform.IPhonePlayer)
		{
            //Bridge.initRecognizer();
            Bridge.initSynthesizer();
		}
	}
}
