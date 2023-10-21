// Tranforms position from object to homogenous space
inline float4 UnityObjectToClipPosAlt(in float4 pos)
{
#if defined(STEREO_CUBEMAP_RENDER_ON)
    return UnityObjectToClipPosODS(pos);
#else
    //return mul(UNITY_MATRIX_VP, mul(unity_ObjectToWorld, pos));

    // Incorporate part of the matrix later to avoid high frequency error
    float4 temp = unity_ObjectToWorld._m00_m10_m20_m30 * pos.xxxx;
    temp = unity_ObjectToWorld._m01_m11_m21_m31 * pos.yyyy + temp;
    temp = unity_ObjectToWorld._m02_m12_m22_m32 * pos.zzzz + temp;
    //temp = unity_ObjectToWorld._m03_m13_m23_m33 * pos.wwww + temp;
    return mul(UNITY_MATRIX_VP, temp) + mul(UNITY_MATRIX_VP, unity_ObjectToWorld._m03_m13_m23_m33 * pos.wwww);
#endif
}

inline float4 UnityObjectToClipPosAlt(in float3 pos)
{
    return UnityObjectToClipPosAlt(float4(pos, 1.0));
}

#if defined(SHADOWS_CUBE) || defined(SHADOWS_DEPTH)
float4 UnityClipSpaceShadowCasterPosAlt(float4 vertex, float3 normal)
{
    //float4 wPos = mul(unity_ObjectToWorld, vertex);
    float4 wPos = UnityObjectToClipPosAlt(vertex);

    if (unity_LightShadowBias.z != 0.0)
    {
        float3 wNormal = UnityObjectToWorldNormal(normal);
        float3 wLight = normalize(UnityWorldSpaceLightDir(wPos.xyz));

        // apply normal offset bias (inset position along the normal)
        // bias needs to be scaled by sine between normal and light direction
        // (http://the-witness.net/news/2013/09/shadow-mapping-summary-part-1/)
        //
        // unity_LightShadowBias.z contains user-specified normal offset amount
        // scaled by world space texel size.

        float shadowCos = dot(wNormal, wLight);
        float shadowSine = sqrt(1-shadowCos*shadowCos);
        float normalBias = unity_LightShadowBias.z * shadowSine;

        //wPos.xyz -= wNormal * normalBias;
        wPos.xyz -= mul(UNITY_MATRIX_VP, wNormal * normalBias);
    }

    //return mul(UNITY_MATRIX_VP, wPos);
    return wPos;
}

// Legacy, not used anymore; kept around to not break existing user shaders
inline float4 UnityClipSpaceShadowCasterPosAlt(float3 vertex, float3 normal)
{
    return UnityClipSpaceShadowCasterPosAlt(float4(vertex, 1), normal);
}

#if defined(SHADOWS_CUBE) && !defined(SHADOWS_CUBE_IN_DEPTH_TEX)
    // Rendering into point light (cubemap) shadows
    #define TRANSFER_SHADOW_CASTER_NOPOS_LEGACY_AS(o,opos) o.vec = mul(unity_ObjectToWorld, v.vertex).xyz - _LightPositionRange.xyz; opos = UnityObjectToClipPos(v.vertex);
    #define TRANSFER_SHADOW_CASTER_NOPOS_AS(o,opos) o.vec = mul(unity_ObjectToWorld, v.vertex).xyz - _LightPositionRange.xyz; opos = UnityObjectToClipPos(v.vertex);
#else
    // Rendering into directional or spot light shadows
    #define TRANSFER_SHADOW_CASTER_NOPOS_LEGACY_AS(o,opos) \
        opos = UnityObjectToClipPosAlt(v.vertex.xyz); \
        opos = UnityApplyLinearShadowBias_AS(opos);
    #define TRANSFER_SHADOW_CASTER_NOPOS_AS(o,opos) \
        opos = UnityClipSpaceShadowCasterPosAlt(v.vertex, v.normal); \
        opos = UnityApplyLinearShadowBias(opos);
#endif

#endif
