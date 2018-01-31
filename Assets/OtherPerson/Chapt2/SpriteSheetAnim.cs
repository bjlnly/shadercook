using UnityEngine;
using System.Collections;

public class SpriteSheetAnim : MonoBehaviour {

    float cellIndex;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () 
    {
	
	}

    void FixedUpdate()
    {
        cellIndex = Mathf.Ceil(Time.time);
        transform.GetComponent<Renderer>().material.SetFloat("_cellIndex", cellIndex);
    }
}
