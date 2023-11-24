shader_type canvas_item;

uniform float reflectionBlur = 0;
uniform float calculatedOffset = 0;
uniform sampler2D noiseTexture;

uniform vec2 distortionScale = vec2(0.3, 0.3);
uniform vec2 distortionSpeed = vec2(0.01, 0.02);
uniform vec2 distortionStrength = vec2(0.3, 0.3);

uniform float waveSmoothing = .01;

uniform float mainWaveSpeed = 2.5;
uniform float mainWaveFrequency = 20;
uniform float mainWaveAmplitude = 0.005;

uniform vec4 shorelineColor : source_color = vec4(1.);
uniform float shorelineSize : hint_range(0., 1.) = 0.0025;
uniform float foamSize : hint_range(0., 1.0) = 0.0025;
uniform float foamStrength : hint_range(0., 1.0) = 0.5;
uniform float foamSpeed;
uniform vec2 foamScale;
uniform float pixelationFactor = 2.0;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    vec2 uv = SCREEN_UV;
    uv.y = 1. - uv.y;
    uv.y -= calculatedOffset;

    vec2 noiseTextureUV = UV * distortionScale;
    noiseTextureUV += TIME * distortionSpeed;
    
    vec2 waterDistortion = texture(noiseTexture, noiseTextureUV).rg;
    waterDistortion.rg *= distortionStrength.xy;
    waterDistortion.rg = smoothstep(0.0, 1., waterDistortion.rg);
    uv += waterDistortion;

	


    vec4 color = textureLod(SCREEN_TEXTURE, uv, reflectionBlur);

    float distFromTop = mainWaveAmplitude * sin(UV.x * mainWaveFrequency + TIME * mainWaveSpeed) + mainWaveAmplitude;
    float waveArea = UV.y - distFromTop;
    waveArea = smoothstep(0., 1. * waveSmoothing, waveArea);
    color.a *= waveArea;

    float shorelineBottom = UV.y - distFromTop - shorelineSize;
    shorelineBottom = smoothstep(0., 1. * waveSmoothing, shorelineBottom);

    float shoreline = waveArea - shorelineBottom;
    color.rgb += shoreline * shorelineColor.rgb + vec3(0.0, 0.0, 0.2); // Ajout de la teinte bleue

    vec4 foamNoise = texture(noiseTexture, UV * foamScale + TIME * foamSpeed);
    foamNoise.r = smoothstep(0.0, foamNoise.r, foamStrength);

    float shorelineFoam = UV.y - distFromTop;
    shorelineFoam = smoothstep(0.0, shorelineFoam, foamSize);

    if (shorelineFoam > 0.0) {
        vec2 roundedUV = floor(uv * pixelationFactor) / pixelationFactor;
        vec4 pixelatedColor = textureLod(SCREEN_TEXTURE, roundedUV, reflectionBlur);
        color.rgb = mix(color.rgb, pixelatedColor.rgb, shorelineFoam);
    }

    shorelineFoam *= foamNoise.r;
    color.rgb += shorelineFoam * shorelineColor.rgb + vec3(0.0, 0.0, 0.2); // Ajout de la teinte bleue pour la mousse

	
	//vec4 text = texture(, grid_uv);
	//COLOR = text;
	
    COLOR = color;
}
