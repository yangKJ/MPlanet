#include <metal_stdlib>
using namespace metal;

typedef struct {
    packed_float2 position;
} Vertex;

typedef struct {
    float4 position [[position]];
    float2 texCoord [[user(texture_coord)]];
    float visibilityFraction;
} RasterizerData;

constant float2 vertices[6] = {
    float2(1,  -1),
    float2(-1,  -1),
    float2(-1,   1),
    float2(1,  -1),
    float2(-1,   1),
    float2(1,   1)
};

float doubleStep(float value, float lowerBound, float upperBound) {
    return step(lowerBound, value) * (1.0 - step(upperBound, value));
}

float fieldFunction(float2 center, float contentScale, float2 position, float2 dimensions, float time) {
    float maxDimension = max(dimensions.x, dimensions.y);
    
    float currentDistance = time * maxDimension;
    float waveWidth = 100.0f * contentScale;
    
    float d = distance(center, position);
    
    float stepFactor = doubleStep(d, currentDistance, currentDistance + waveWidth);
    float value = abs(sin((-currentDistance + d) * M_PI_F / (waveWidth)));
    
    return value * stepFactor * 1.0f;
}

float linearDecay(float parameter, float maxParameter) {
    float decay = clamp(1.0 - parameter / maxParameter, 0.0, 1.0);
    return decay;
}

// 顶点 shader 的 buffer 索引必须严格对齐 Swift 端 `renderEncoder.setVertexBytes(... index:)` 的顺序:
//   buffer(0) -> center         (simd_uint2)  Swift setVertexBytes(center,         index: 0)
//   buffer(1) -> resolution     (simd_uint2)  Swift setVertexBytes(resolution,     index: 1)
//   buffer(2) -> time           (float)       Swift setVertexBytes(time,           index: 2)
//   buffer(3) -> contentScale   (float)       Swift setVertexBytes(contentScale,   index: 3)
// 历史 bug: 之前 shader 多了一个 gridResolution [[buffer(1)]],导致 resolution/time/contentScale
// 的 [[buffer(N)]] 全部错位一格,运行时访问到的是相邻 buffer 的字节,触发 GPU 取址越界
// 或读到错误的数值 (center.x/resolution.y 互换等)。现已删除 gridResolution 参数。
vertex RasterizerData rippleVertex(
    uint vid [[ vertex_id ]],
    device const uint2 &center [[buffer(0)]],
    device const uint2 &resolution [[buffer(1)]],
    device const float &time [[buffer(2)]],
    device const float &contentScale [[buffer(3)]]
) {
    uint triangleIndex = vid / 6;
    uint vertexIndex = vid % 6;
    float2 in = vertices[vertexIndex];
    in.x = (in.x + 1.0) * 0.5;
    in.y = (in.y + 1.0) * 0.5;
    
    float2 dimensions = float2(resolution.x, resolution.y);

    // why: 历史代码使用 gridSize=1000 生成 6M vertex/帧,老设备卡顿。
    // 改为全屏 quad (vid 直接索引 6 个顶点),不再需要 gridResolution/gridStep。
    float2 position = float2(in.x, in.y);
    float2 texCoord = float2(position.x, 1.0 - position.y);
    
    float zPosition = fieldFunction(float2(center), contentScale, float2(position.x * dimensions.x, (1.0 - position.y) * dimensions.y), dimensions, time);
    zPosition *= 0.5f;
    
    float leftEdgeDistance = abs(position.x);
    float rightEdgeDistance = abs(1.0 - position.x);
    float topEdgeDistance = abs(position.y);
    float bottomEdgeDistance = abs(1.0 - position.y);
    float minEdgeDistance = min(leftEdgeDistance, rightEdgeDistance);
    minEdgeDistance = min(minEdgeDistance, topEdgeDistance);
    minEdgeDistance = min(minEdgeDistance, bottomEdgeDistance);
    float edgeNorm = 0.1f;
    float edgeDistance = min(minEdgeDistance / edgeNorm, 1.0);
    zPosition *= edgeDistance;
    
    zPosition *= max(0.0, min(1.0, linearDecay(time, 0.7)));
    
    float3 camPosition = float3(0.0, 0.0f, 1.0f);
    float3 camTarget = float3(0.0, 0.0, 0.0);
    float3 forwardVector = normalize(camPosition - camTarget);
    float3 rightVector = normalize(cross(float3(0.0, 1.0, 0.0), forwardVector));
    float3 upVector = normalize(cross(forwardVector, rightVector));
    
    float translationX = dot(camPosition, rightVector);
    float translationY = dot(camPosition, upVector);
    float translationZ = dot(camPosition, forwardVector);
    
    float4x4 viewTransform = float4x4(
        rightVector.x, upVector.x, forwardVector.x, 0.0,
        rightVector.y, upVector.y, forwardVector.y, 0.0,
        rightVector.z, upVector.z, forwardVector.z, 0.0,
        -translationX, -translationY, -translationZ, 1.0
    );
    
    float4x4 projectionTransform = float4x4(
        1.0, 0.0, 0.0, 0.0,
        0.0, 1.0, 0.0, 0.0,
        0.0, 0.0, 1.0, 0.0,
        0.0, 0.0, -1.0 / 500.0, 1.0
    );
    
    float4x4 mvp = projectionTransform * viewTransform;
    
    float zNorm = 0.1;
    
    float4 transformedPosition = float4(float2(-1.0 + position.x * 2.0, -1.0 + position.y * 2.0), -zPosition * zNorm, 1.0) * mvp;
    transformedPosition.x /= transformedPosition.w;
    transformedPosition.y /= transformedPosition.w;
    transformedPosition.z /= transformedPosition.w;
    
    position.x = transformedPosition.x;
    position.y = transformedPosition.y;
    
    RasterizerData out;
    out.position = vector_float4(0.0, 0.0, 0.0, 1.0);
    out.position.x = transformedPosition.x;
    out.position.y = transformedPosition.y;
    out.position.z = transformedPosition.z + zNorm;
    
    out.visibilityFraction = zPosition == 0.0 ? 0.0 : 1.0;
    
    out.texCoord = texCoord;
            
    return out;
}

fragment half4 rippleFragment(
    RasterizerData in[[stage_in]],
    texture2d<half> texture[[ texture(0) ]]
) {
    constexpr sampler textureSampler(min_filter::linear, mag_filter::linear, mip_filter::linear, address::clamp_to_edge);
    
    float2 texCoord = in.texCoord;
    float4 rgb = float4(texture.sample(textureSampler, texCoord));
    
    float4 out = float4(rgb.xyz, 1.0);
    /*out.r = 0.0;
    out.g = 0.0;
    out.b = 1.0;*/
    
    out.a = 1.0 - step(in.visibilityFraction, 0.5);
    
    out.r *= out.a;
    out.g *= out.a;
    out.b *= out.a;
    
    return half4(out);
}
