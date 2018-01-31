using UnityEngine;
using System.Collections;
using System;

public class ProceduralTextureTest : MonoBehaviour {
    #region public 变量
        public int WidthHeight = 512;
        public Texture2D GeneratedTexture;
    #endregion

    #region private 变量
        private Material _currentMaterial;    
        private Vector2 _centerPosition;
    #endregion

    private void Start() {
        if (!_currentMaterial)
        {
            _currentMaterial = transform.GetComponent<Renderer>().sharedMaterial;
            if (!_currentMaterial)
            {
                Debug.LogWarning("找不到材质球:"+transform.name);
            }
        }

        if (_currentMaterial)
        {
            _centerPosition = new Vector2(0.5f, 0.5f);
            GeneratedTexture = GenerateParabola();

            _currentMaterial.SetTexture("_MainTex", GeneratedTexture);
        }
    }

    private Texture2D GenerateParabola()
    {
        Texture2D proceduralTexture = new Texture2D(WidthHeight, WidthHeight);

        Vector2 centerPixelPosition = _centerPosition * WidthHeight;

        for (int x = 0; x < WidthHeight; x++)
        {
            for (int y = 0; y < WidthHeight; y++)
            {
                Vector2 currentPosition = new Vector2(x, y);
                float pixelDistance = Vector2.Distance(currentPosition, centerPixelPosition)/(WidthHeight*0.5f);

                pixelDistance = Mathf.Abs(1-Mathf.Clamp(pixelDistance, 0f, 1f));
#region Annular
                //pixelDistance = (Mathf.Sin(pixelDistance * 30.0f) * pixelDistance);
#endregion

#region 点积
                // Vector2 pixelDirection = centerPixelPosition - currentPosition;
                // pixelDirection.Normalize();
                // float rightDirection = Vector2.Dot(pixelDirection, Vector3.right);
                // float leftDirection = Vector2.Dot(pixelDirection, Vector3.left);
                // float upDirection = Vector2.Dot(pixelDirection, Vector3.up);
                // Color pixelColor = new Color(rightDirection, leftDirection, upDirection, 1.0f);
#endregion

#region 角度
                Vector2 pixelDirection = centerPixelPosition - currentPosition;
                pixelDirection.Normalize();
                float rightDirection = Vector2.Angle(pixelDirection, Vector3.right) / 360;
                float leftDirection = Vector2.Angle(pixelDirection, Vector3.left) / 360;
                float upDirection = Vector2.Angle(pixelDirection, Vector3.up) / 360;
                Color pixelColor = new Color(rightDirection, leftDirection, upDirection, 1.0f);
#endregion
                //Color pixelColor = new Color(pixelDistance, pixelDistance, pixelDistance, 1.0f);
                proceduralTexture.SetPixel(x,y,pixelColor);
            }
        }
        proceduralTexture.Apply();
        return proceduralTexture;
    }
}
