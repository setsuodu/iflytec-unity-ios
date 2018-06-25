using System.IO;
using UnityEditor;
using UnityEditor.iOS.Xcode;
using UnityEditor.Callbacks;

public class XCodePostProcess
{
	[PostProcessBuild]
	static void OnPostprocessBuild(BuildTarget target, string path)
	{
		ModifyProj(path);
		SetPlist(path);
	}

	public static void ModifyProj(string path)
	{
		string projPath = PBXProject.GetPBXProjectPath(path);
		PBXProject pbxProj = new PBXProject();
		pbxProj.ReadFromString(File.ReadAllText(projPath));

		// 配置目标
		string targetGuid = pbxProj.TargetGuidByName("Unity-iPhone");

		// 关闭bitcode
        pbxProj.SetBuildProperty(targetGuid, "ENABLE_BITCODE", "false");

		// 添加.tbd
		pbxProj.AddFileToBuild(targetGuid, pbxProj.AddFile("usr/lib/libz.tbd", "Frameworks/libz.tbd", PBXSourceTree.Sdk));
		pbxProj.AddFileToBuild(targetGuid, pbxProj.AddFile("usr/lib/libc++.tbd", "Frameworks/libc++.tbd", PBXSourceTree.Sdk));
		pbxProj.AddFileToBuild(targetGuid, pbxProj.AddFile("usr/lib/Libicucore.tbd", "Frameworks/Libicucore.tbd", PBXSourceTree.Sdk));

		// 添加系统内置框架
		pbxProj.AddFrameworkToProject(targetGuid, "AVFoundation.framework", false);
		pbxProj.AddFrameworkToProject(targetGuid, "SystemConfiguration.framework", false);
		pbxProj.AddFrameworkToProject(targetGuid, "Foundation.framework", false);
		pbxProj.AddFrameworkToProject(targetGuid, "CoreTelephony.framework", false);
		pbxProj.AddFrameworkToProject(targetGuid, "AudioToolbox.framework", false);
		pbxProj.AddFrameworkToProject(targetGuid, "UIKit.framework", false);
		pbxProj.AddFrameworkToProject(targetGuid, "CoreLocation.framework", false);
		pbxProj.AddFrameworkToProject(targetGuid, "Contacts.framework", false);
		pbxProj.AddFrameworkToProject(targetGuid, "AddressBook.framework", false);
		pbxProj.AddFrameworkToProject(targetGuid, "QuartzCore.framework", false);
		pbxProj.AddFrameworkToProject(targetGuid, "CoreGraphics.framework", false);
		pbxProj.AddFrameworksBuildPhase(targetGuid);

		// 设置teamID
		//..

		File.WriteAllText(projPath, pbxProj.WriteToString());
	}

	static void SetPlist(string path)
	{
		string plistPath = path + "/Info.plist";
		PlistDocument plist = new PlistDocument();
		plist.ReadFromString(File.ReadAllText(plistPath));

		// Information Property List
		PlistElementDict plistDict = plist.root;
		plistDict.SetString("NSMicrophoneUsageDescription", "");
		plistDict.SetString("NSLocationUsageDescription", "");
		plistDict.SetString("NSLocationAlwaysUsageDescription", "");
		plistDict.SetString("NSContactsUsageDescription", "");

		File.WriteAllText(plistPath, plist.WriteToString());
	}
}
