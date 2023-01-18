using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestComponent : MonoBehaviour
{
    public RenderTexture myRt;
    [OverrideFrom("myRt")] public RTFormatParameter format;
}
