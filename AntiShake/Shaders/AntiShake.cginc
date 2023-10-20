// Tranforms position from object to homogenous space
inline float4 UnityObjectToClipPosAlt(in float3 pos)
{
#if defined(STEREO_CUBEMAP_RENDER_ON)
    return UnityObjectToClipPosODS(pos);
#else
    //return mul(UNITY_MATRIX_VP, mul(unity_ObjectToWorld, float4(pos, 1.0)));

    // Incorporate part of the matrix later to avoid high frequency error
    float4 temp = unity_ObjectToWorld._m00_m10_m20_m30 * pos.xxxx;
    temp = unity_ObjectToWorld._m01_m11_m21_m31 * pos.yyyy + temp;
    temp = unity_ObjectToWorld._m02_m12_m22_m32 * pos.zzzz + temp;
    //temp = unity_ObjectToWorld._m03_m13_m23_m33 + temp;
    return mul(UNITY_MATRIX_VP, temp) + mul(UNITY_MATRIX_VP, unity_ObjectToWorld._m03_m13_m23_m33);
#endif
}
