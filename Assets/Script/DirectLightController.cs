using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DirectLightController : MonoBehaviour
{
    private Transform m_DirLightTrans;
    private float m_YEulerAngle = 0;

    // Start is called before the first frame update
    void Start()
    {
        m_DirLightTrans = GameObject.Find("Directional Light").transform;
    }

    // Update is called once per frame
    void Update()
    {
        m_YEulerAngle += 1; 
        m_DirLightTrans.localRotation = Quaternion.Euler(50, m_YEulerAngle, 0);
    }
}
