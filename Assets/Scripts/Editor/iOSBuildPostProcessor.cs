#if UNITY_EDITOR && UNITY_IOS
using UnityEditor;
using UnityEditor.Callbacks;
using UnityEditor.iOS.Xcode;
using System.IO;

public class iOSBuildPostProcessor
{
    [PostProcessBuild(999)]
    public static void OnPostProcessBuild(BuildTarget buildTarget, string pathToBuiltProject)
    {
        // iOSビルドの時のみ実行
        if (buildTarget != BuildTarget.iOS)
            return;

        try
        {
            // Xcodeプロジェクトを読み込み
            string projectPath = PBXProject.GetPBXProjectPath(pathToBuiltProject);
            PBXProject project = new PBXProject();
            project.ReadFromFile(projectPath);

            // メインターゲットを取得
            string targetGuid = project.GetUnityMainTargetGuid();

            // 自動署名を有効化
            project.SetBuildProperty(targetGuid, "CODE_SIGN_STYLE", "Automatic");
            project.SetBuildProperty(targetGuid, "CODE_SIGN_IDENTITY", "Apple Development");
            project.SetBuildProperty(targetGuid, "PROVISIONING_PROFILE_SPECIFIER", "");
            project.SetBuildProperty(targetGuid, "PROVISIONING_PROFILE", "");
            
            // Team IDを設定（環境変数から取得）
            string teamId = System.Environment.GetEnvironmentVariable("APPLE_TEAM_ID");
            if (!string.IsNullOrEmpty(teamId))
            {
                project.SetBuildProperty(targetGuid, "DEVELOPMENT_TEAM", teamId);
            }

            // その他の設定
            project.SetBuildProperty(targetGuid, "ENABLE_BITCODE", "NO");
            project.SetBuildProperty(targetGuid, "IPHONEOS_DEPLOYMENT_TARGET", "12.0");

            // プロジェクトを保存
            project.WriteToFile(projectPath);

            // Info.plistの設定
            string plistPath = Path.Combine(pathToBuiltProject, "Info.plist");
            PlistDocument plist = new PlistDocument();
            plist.ReadFromFile(plistPath);

            // Bundle IDを設定
            plist.root.SetString("CFBundleIdentifier", "com.yousan");

            // plistを保存
            plist.WriteToFile(plistPath);
        }
        catch (System.Exception e)
        {
            UnityEngine.Debug.LogWarning($"iOS post process build failed: {e.Message}");
        }
    }
}
#endif