using UnityEngine;
using System.Collections;
using UnityEditor;


public class GenerateStaticCubemap : ScriptableWizard 
{
    public Transform renderPosition;
    public Cubemap cubemap;

    void OnizardUpdate()
    {
        helpString = "Select transform to render" + "from and cubemap to render into";
        if (renderPosition != null && cubemap != null)
        {
            isValid = true;
        }
        else
        {
            isValid = false;
        }
    }

    void OnWizardCreate()
    {
        //添加一个Camera，用来创建Cubemap的。
        GameObject go = new GameObject("CubemapCamera", typeof(Camera));

        go.transform.position = renderPosition.position;
        go.transform.rotation = Quaternion.identity;

        go.GetComponent<Camera>().RenderToCubemap(cubemap);

        DestroyImmediate(go);
    }

    [MenuItem("CookBookShaders/Render Cubemap")]
    static void RenderCubemap()
    {
        ScriptableWizard.DisplayWizard("Render Cube", typeof(GenerateStaticCubemap), "Render");
    }
}
