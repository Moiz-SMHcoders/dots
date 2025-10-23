// float getSdfRectangle(in vec2 p, in vec2 xy, in vec2 b)
// {
//     vec2 d = abs(p - xy) - b;
//     return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
// }
//
// // Based on Inigo Quilez's 2D distance functions article: https://iquilezles.org/articles/distfunctions2d/
// // Potencially optimized by eliminating conditionals and loops to enhance performance and reduce branching
//
// float seg(in vec2 p, in vec2 a, in vec2 b, inout float s, float d) {
//     vec2 e = b - a;
//     vec2 w = p - a;
//     vec2 proj = a + e * clamp(dot(w, e) / dot(e, e), 0.0, 1.0);
//     float segd = dot(p - proj, p - proj);
//     d = min(d, segd);
//
//     float c0 = step(0.0, p.y - a.y);
//     float c1 = 1.0 - step(0.0, p.y - b.y);
//     float c2 = 1.0 - step(0.0, e.x * w.y - e.y * w.x);
//     float allCond = c0 * c1 * c2;
//     float noneCond = (1.0 - c0) * (1.0 - c1) * (1.0 - c2);
//     float flip = mix(1.0, -1.0, step(0.5, allCond + noneCond));
//     s *= flip;
//     return d;
// }
//
// float getSdfParallelogram(in vec2 p, in vec2 v0, in vec2 v1, in vec2 v2, in vec2 v3) {
//     float s = 1.0;
//     float d = dot(p - v0, p - v0);
//
//     d = seg(p, v0, v3, s, d);
//     d = seg(p, v1, v0, s, d);
//     d = seg(p, v2, v1, s, d);
//     d = seg(p, v3, v2, s, d);
//
//     return s * sqrt(d);
// }
//
// vec2 normalize(vec2 value, float isPosition) {
//     return (value * 2.0 - (iResolution.xy * isPosition)) / iResolution.y;
// }
//
// float antialising(float distance) {
//     return 1. - smoothstep(0., normalize(vec2(2., 2.), 0.).x, distance);
// }
//
// float determineStartVertexFactor(vec2 a, vec2 b) {
//     // Conditions using step
//     float condition1 = step(b.x, a.x) * step(a.y, b.y); // a.x < b.x && a.y > b.y
//     float condition2 = step(a.x, b.x) * step(b.y, a.y); // a.x > b.x && a.y < b.y
//
//     // If neither condition is met, return 1 (else case)
//     return 1.0 - max(condition1, condition2);
// }
//
// vec2 getRectangleCenter(vec4 rectangle) {
//     return vec2(rectangle.x + (rectangle.z / 2.), rectangle.y - (rectangle.w / 2.));
// }
// float ease(float x) {
//     return pow(1.0 - x, 3.0);
// }
//
// const vec4 TRAIL_COLOR = vec4(1., 1., 0., 1.0);
// const float DURATION = 0.5; //IN SECONDS
//
// void mainImage(out vec4 fragColor, in vec2 fragCoord)
// {
//     #if !defined(WEB)
//     fragColor = texture(iChannel0, fragCoord.xy / iResolution.xy);
//     #endif
//     // Normalization for fragCoord to a space of -1 to 1;
//     vec2 vu = normalize(fragCoord, 1.);
//     vec2 offsetFactor = vec2(-.5, 0.5);
//
//     // Normalization for cursor position and size;
//     // cursor xy has the postion in a space of -1 to 1;
//     // zw has the width and height
//     vec4 currentCursor = vec4(normalize(iCurrentCursor.xy, 1.), normalize(iCurrentCursor.zw, 0.));
//     vec4 previousCursor = vec4(normalize(iPreviousCursor.xy, 1.), normalize(iPreviousCursor.zw, 0.));
//
//     // When drawing a parellelogram between cursors for the trail i need to determine where to start at the top-left or top-right vertex of the cursor
//     float vertexFactor = determineStartVertexFactor(currentCursor.xy, previousCursor.xy);
//     float invertedVertexFactor = 1.0 - vertexFactor;
//
//     // Set every vertex of my parellogram
//     vec2 v0 = vec2(currentCursor.x + currentCursor.z * vertexFactor, currentCursor.y - currentCursor.w);
//     vec2 v1 = vec2(currentCursor.x + currentCursor.z * invertedVertexFactor, currentCursor.y);
//     vec2 v2 = vec2(previousCursor.x + currentCursor.z * invertedVertexFactor, previousCursor.y);
//     vec2 v3 = vec2(previousCursor.x + currentCursor.z * vertexFactor, previousCursor.y - previousCursor.w);
//
//     float sdfCurrentCursor = getSdfRectangle(vu, currentCursor.xy - (currentCursor.zw * offsetFactor), currentCursor.zw * 0.5);
//     float sdfTrail = getSdfParallelogram(vu, v0, v1, v2, v3);
//
//     float progress = clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1.0);
//     float easedProgress = ease(progress);
//     // Distance between cursors determine the total length of the parallelogram;
//     vec2 centerCC = getRectangleCenter(currentCursor);
//     vec2 centerCP = getRectangleCenter(previousCursor);
//     float lineLength = distance(centerCC, centerCP);
//
//     vec4 newColor = vec4(fragColor);
//     // Compute fade factor based on distance along the trail
//     float fadeFactor = 1.0 - smoothstep(lineLength, sdfCurrentCursor, easedProgress * lineLength);
//
//     // Apply fading effect to trail color
//     vec4 fadedTrailColor = TRAIL_COLOR * fadeFactor;
//
//     // Blend trail with fade effect
//     newColor = mix(newColor, fadedTrailColor, antialising(sdfTrail));
//     // Draw current cursor
//     newColor = mix(newColor, TRAIL_COLOR, antialising(sdfCurrentCursor));
//     newColor = mix(newColor, fragColor, step(sdfCurrentCursor, 0.));
//     fragColor = mix(fragColor, newColor, step(sdfCurrentCursor, easedProgress * lineLength));
// }





// cursor_smear_fade.glsl — tuned for Ghostty:
// - background: #0c0b0f (very dark purple)
// - cursor:     #bea3c7 (mauve)
// - theme:      Zenburn-like soft contrast

float getSdfRectangle(in vec2 p, in vec2 xy, in vec2 b)
{
    vec2 d = abs(p - xy) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

// Based on Inigo Quilez's 2D distance functions article: https://iquilezles.org/articles/distfunctions2d/
// Potentially optimized by eliminating conditionals and loops to enhance performance and reduce branching
float seg(in vec2 p, in vec2 a, in vec2 b, inout float s, float d) {
    vec2 e = b - a;
    vec2 w = p - a;
    vec2 proj = a + e * clamp(dot(w, e) / dot(e, e), 0.0, 1.0);
    float segd = dot(p - proj, p - proj);
    d = min(d, segd);

    float c0 = step(0.0, p.y - a.y);
    float c1 = 1.0 - step(0.0, p.y - b.y);
    float c2 = 1.0 - step(0.0, e.x * w.y - e.y * w.x);
    float allCond = c0 * c1 * c2;
    float noneCond = (1.0 - c0) * (1.0 - c1) * (1.0 - c2);
    float flip = mix(1.0, -1.0, step(0.5, allCond + noneCond));
    s *= flip;
    return d;
}

float getSdfParallelogram(in vec2 p, in vec2 v0, in vec2 v1, in vec2 v2, in vec2 v3) {
    float s = 1.0;
    float d = dot(p - v0, p - v0);

    d = seg(p, v0, v3, s, d);
    d = seg(p, v1, v0, s, d);
    d = seg(p, v2, v1, s, d);
    d = seg(p, v3, v2, s, d);

    return s * sqrt(d);
}

vec2 normalize(vec2 value, float isPosition) {
    return (value * 2.0 - (iResolution.xy * isPosition)) / iResolution.y;
}

float antialising(float distance) {
    return 1. - smoothstep(0., normalize(vec2(2., 2.), 0.).x, distance);
}

float determineStartVertexFactor(vec2 a, vec2 b) {
    // a.x < b.x && a.y > b.y  OR  a.x > b.x && a.y < b.y  -> flip start vertex
    float condition1 = step(b.x, a.x) * step(a.y, b.y);
    float condition2 = step(a.x, b.x) * step(b.y, a.y);
    return 1.0 - max(condition1, condition2);
}

vec2 getRectangleCenter(vec4 rectangle) {
    return vec2(rectangle.x + (rectangle.z / 2.), rectangle.y - (rectangle.w / 2.));
}

float ease(float x) {
    return pow(1.0 - x, 3.0);
}

/* -------------------- Color & trail tuning -------------------- */
/* #bea3c7 ≈ (190,163,199)/255 → (0.745, 0.639, 0.780) */
const vec4 CURSOR_COLOR     = vec4(0.784, 0.639, 0.427, 1.0); // gruvbox yellow
const vec4 TRAIL_BASE      = CURSOR_COLOR;                     // trail matches cursor hue
const float TRAIL_INTENSITY = 0.85;                            // trim global brightness
const float DURATION        = 0.5;                             // seconds for trail fade

// Optional subtle Zenburn tail tint (warm yellow). Uncomment to bias far trail slightly.
// const vec3 TRAIL_TINT = vec3(0.941, 0.875, 0.686);          // #f0dfaf
/* ------------------------------------------------------------- */

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    #if !defined(WEB)
    fragColor = texture(iChannel0, fragCoord.xy / iResolution.xy);
    #endif

    // Normalization for fragCoord to a space of -1 to 1
    vec2 vu = normalize(fragCoord, 1.);
    vec2 offsetFactor = vec2(-.5, 0.5);

    // iCurrentCursor.xy: position (-1..1), .zw: width/height in normalized units
    vec4 currentCursor  = vec4(normalize(iCurrentCursor.xy, 1.),  normalize(iCurrentCursor.zw, 0.));
    vec4 previousCursor = vec4(normalize(iPreviousCursor.xy, 1.), normalize(iPreviousCursor.zw, 0.));

    // Parallelogram vertices for the trail (connect previous→current cursor rects)
    float vertexFactor           = determineStartVertexFactor(currentCursor.xy, previousCursor.xy);
    float invertedVertexFactor   = 1.0 - vertexFactor;

    vec2 v0 = vec2(currentCursor.x + currentCursor.z * vertexFactor,        currentCursor.y - currentCursor.w);
    vec2 v1 = vec2(currentCursor.x + currentCursor.z * invertedVertexFactor, currentCursor.y);
    vec2 v2 = vec2(previousCursor.x + currentCursor.z * invertedVertexFactor, previousCursor.y);
    vec2 v3 = vec2(previousCursor.x + currentCursor.z * vertexFactor,        previousCursor.y - previousCursor.w);

    float sdfCurrentCursor = getSdfRectangle(vu, currentCursor.xy - (currentCursor.zw * offsetFactor), currentCursor.zw * 0.5);
    float sdfTrail         = getSdfParallelogram(vu, v0, v1, v2, v3);

    float progress      = clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1.0);
    float easedProgress = ease(progress);

    // Trail length based on cursor centers
    vec2 centerCC = getRectangleCenter(currentCursor);
    vec2 centerCP = getRectangleCenter(previousCursor);
    float lineLength = distance(centerCC, centerCP);

    vec4 newColor = vec4(fragColor);

    // Fade factor: slightly brighter early, fades smoothly along the trail
    float fadeFactor = 0.25 + 0.75 * (1.0 - smoothstep(lineLength, sdfCurrentCursor, easedProgress * lineLength));

    // Base trail RGB (soft, matched to cursor color)
    vec3 trailRGB = TRAIL_BASE.rgb * fadeFactor * TRAIL_INTENSITY;

    // Optional warm tail tint — blend in at the far end (uncomment if using TRAIL_TINT above)
    // trailRGB = mix(TRAIL_TINT, trailRGB, easedProgress);

    vec4 fadedTrailColor = vec4(trailRGB, 1.0);

    // Blend trail & cursor
    newColor = mix(newColor, fadedTrailColor, antialising(sdfTrail));        // trail
    newColor = mix(newColor, CURSOR_COLOR,     antialising(sdfCurrentCursor)); // current cursor
    newColor = mix(newColor, fragColor,        step(sdfCurrentCursor, 0.0));   // preserve bg inside cursor rect
    fragColor = mix(fragColor, newColor,       step(sdfCurrentCursor, easedProgress * lineLength));
}
