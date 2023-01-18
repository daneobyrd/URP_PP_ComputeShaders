using UnityEngine;

[RequireComponent(typeof(Camera))]
public class JFA : MonoBehaviour {
    public ComputeShader JFAShader;

    private int InitSeedKernel;
    private int JFAKernel;
    private int FillDistanceTransformKernel;
    private RenderTexture tmp1, tmp2;
    private bool generated = false;
    private Camera cam;
    
    void Start() {
        cam = GetComponent<Camera>();
        InitSeedKernel = JFAShader.FindKernel("InitSeed");
        JFAKernel = JFAShader.FindKernel("JFA");
        FillDistanceTransformKernel = JFAShader.FindKernel("FillDistanceTransform");
        cam.SetReplacementShader(Shader.Find("Unlit/WaterIntersectionReplacement"), "RenderType");
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination) {
        InitRenderTexture(source);
        int threadGroupsX = Mathf.CeilToInt(source.width / 8.0f);
        int threadGroupsY = Mathf.CeilToInt(source.height / 8.0f);
        // Init Seed
        JFAShader.SetTexture(InitSeedKernel, "InputTexture", source);
        JFAShader.SetTexture(InitSeedKernel, "Source", tmp1);
        JFAShader.SetInt("Width", source.width);
        JFAShader.SetInt("Height", source.height);
        JFAShader.Dispatch(InitSeedKernel, threadGroupsX, threadGroupsY, 1);
        // Graphics.Blit(tmp1, destination);

        // JFA
        int stepAmount = (int)Mathf.Log(Mathf.Max(source.width, source.height), 2);
        //Debug.Log("stepAmount:"+ stepAmount);
        for (int i = 0; i < stepAmount; i++) {
            int step = (int)Mathf.Pow(2, stepAmount - i - 1);
            //Debug.Log("step:" + step);
            JFAShader.SetInt("Step", step);
            JFAShader.SetTexture(JFAKernel, "Source", tmp1);
            JFAShader.SetTexture(JFAKernel, "Result", tmp2);

            JFAShader.Dispatch(JFAKernel, threadGroupsX, threadGroupsY, 1);
            Graphics.Blit(tmp2, tmp1);
        }

        JFAShader.SetTexture(FillDistanceTransformKernel, "Source", tmp1);
        JFAShader.SetTexture(FillDistanceTransformKernel, "Result", tmp2);
        JFAShader.Dispatch(FillDistanceTransformKernel, threadGroupsX, threadGroupsY, 1);

        Graphics.Blit(tmp2, destination);
    }

    private void InitRenderTexture(RenderTexture source) {
        if (tmp1 == null || tmp1.width != source.width || tmp1.height != source.height) {
            // Release render texture if we already have one
            if (tmp1 != null)
                tmp1.Release();
            if (tmp2 != null)
                tmp2.Release();
            // Get a render target for Ray Tracing
            tmp1 = new RenderTexture(source.width, source.height, 0,
                RenderTextureFormat.ARGBFloat, RenderTextureReadWrite.Linear);
            tmp1.enableRandomWrite = true;
            tmp1.Create();

            tmp2 = new RenderTexture(source.width, source.height, 0,
               RenderTextureFormat.ARGBFloat, RenderTextureReadWrite.Linear);
            tmp2.enableRandomWrite = true;
            tmp2.Create();
        }


        RenderTexture rt = UnityEngine.RenderTexture.active;
        UnityEngine.RenderTexture.active = tmp1;
        GL.Clear(true, true, Color.clear);
        UnityEngine.RenderTexture.active = rt;
    }

    private static void InitRenderTexture(RenderTexture source, out RenderTexture tmp1, out RenderTexture tmp2) {
        // if (tmp1 == null || tmp1.width != source.width || tmp1.height != source.height) {
        //     // Release render texture if we already have one
        //     if (tmp1 != null)
        //         tmp1.Release();
        //     if (tmp2 != null)
        //         tmp2.Release();
        //     // Get a render target for Ray Tracing
        // }

        tmp1 = new RenderTexture(source.width, source.height, 0,
            RenderTextureFormat.ARGBFloat, RenderTextureReadWrite.Linear);
        tmp1.enableRandomWrite = true;
        tmp1.Create();

        tmp2 = new RenderTexture(source.width, source.height, 0,
            RenderTextureFormat.ARGBFloat, RenderTextureReadWrite.Linear);
        tmp2.enableRandomWrite = true;
        tmp2.Create();

        RenderTexture rt = UnityEngine.RenderTexture.active;
        UnityEngine.RenderTexture.active = tmp1;
        GL.Clear(true, true, Color.clear);
        UnityEngine.RenderTexture.active = rt;
    }

    public static RenderTexture RunJFA(RenderTexture source) {
        ComputeShader JFAShader = Object.Instantiate(Resources.Load<ComputeShader>("JFA"));
        RenderTexture tmp1, tmp2;
        InitRenderTexture(source, out tmp1, out tmp2);
        int initSeedKernel = JFAShader.FindKernel("InitSeed");
        int fillDistanceTransformKernel = JFAShader.FindKernel("FillDistanceTransform");
        int JFAKernel = JFAShader.FindKernel("JFA");

        int threadGroupsX = Mathf.CeilToInt(source.width / 8.0f);
        int threadGroupsY = Mathf.CeilToInt(source.height / 8.0f);
        // Init Seed
        JFAShader.SetTexture(initSeedKernel, "InputTexture", source);
        JFAShader.SetTexture(initSeedKernel, "Source", tmp1);
        JFAShader.SetInt("Width", source.width);
        JFAShader.SetInt("Height", source.height);
        JFAShader.Dispatch(initSeedKernel, threadGroupsX, threadGroupsY, 1);
        // Graphics.Blit(tmp1, destination);

        // JFA
        int stepAmount = (int)Mathf.Log(Mathf.Max(source.width, source.height), 2);
        //Debug.Log("stepAmount:"+ stepAmount);
        for (int i = 0; i < stepAmount; i++) {
            int step = (int)Mathf.Pow(2, stepAmount - i - 1);
            //Debug.Log("step:" + step);
            JFAShader.SetInt("Step", step);
            JFAShader.SetTexture(JFAKernel, "Source", tmp1);
            JFAShader.SetTexture(JFAKernel, "Result", tmp2);

            JFAShader.Dispatch(JFAKernel, threadGroupsX, threadGroupsY, 1);
            Graphics.Blit(tmp2, tmp1);
        }

        JFAShader.SetTexture(fillDistanceTransformKernel, "Source", tmp1);
        JFAShader.SetTexture(fillDistanceTransformKernel, "Result", tmp2);
        JFAShader.Dispatch(fillDistanceTransformKernel, threadGroupsX, threadGroupsY, 1);

        RenderTexture.active = null;

        tmp1.Release();
        return tmp2;
    }
}
