Shader "My Space/Skybox/UniverseSkybox"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _BaseColor ("Base Color",Color) = (1,1,1,1)
        
        [Header(Sun and Moon)]
        _SunSize ("Sun Size",Float) = 1
        _SunInnerBoundary("Sun Inner Boundary",Range(0,1)) = 0.1
        _SunOuterBoundary("Sun Outer Boundary",Range(0,1)) = 0.1
        
        _MoonOffset ("Moon Offset",Range(0,1)) = 0.1
        _MoonSize ("Moon Size",Float) = 1
        [Space(5)]
        [Header(Day and Night)]
        _DayBottomColor ("Day Bottom Color",Color) = (1,1,1,1)
        _DayMidColor ("Day Mid Color",Color) = (1,1,1,1)
        _DayTopColor ("Day Top Color",Color) = (1,1,1,1)
        _NightBottomColor ("Night Bottom Color",Color) = (1,1,1,1)
        _NightMidColor ("Night Mid Color",Color) = (1,1,1,1)
        _NightTopColor ("Night Top Color",Color) = (1,1,1,1)
        
        [Space(5)]
        [Header(Star and Cloud)]
        _SunColor ("Sun Color",Color) = (1,1,1,1)
        _MoonColor ("Moon Color",Color) = (1,1,1,1)
        _StarTex ("Star Tex",2D) = "white"{}
        _StarNoiseTex ("Star Noise Tex",2D) = "white"{}
        _StarSpeed ("Star Speed",Range(-1,1)) = 0.2
        _StarsCutoff ("Stars Cutoff",Range(0,1)) = 0.2
        
        [Space(5)]
        _CloudTex ("Cloud Tex",2D) = "white"{}
        _CloudSpeed ("Cloud Speed",Range(-1,1)) = 0.2
        _CloudCutoff ("Cloud Cutoff",Range(0,1)) = 0.2
        _CloudScale ("Cloud Scale",Range(0,20)) = 0.2
        _CloudColorDay ("Cloud Color Day",Color) = (1,1,1,1)
        _CloudColorNight ("Cloud Color Night",Color) = (1,1,1,1)
        _CloudBrightnessDay ("Cloud Brightness Day",Range(0,1)) = 0.2
        _CloudBrightnessNight ("Cloud Brightness Night",Range(0,1)) = 0.2
        _CloudColorDaySec  ("Cloud Color Day Sec",Color) = (1,1,1,1)
        _CloudColorNightSec  ("Cloud Color Day Sec",Color) = (1,1,1,1)
        [Space(5)]
        _DistortTex ("Distort Tex",2D) = "white"{}
        _DistortSpeed ("Distort Speed",Range(-1,1)) = 0.2
        _DistortScale ("Distort Scale",Range(0,20)) = 0.2
        
        _Fuzziness("Cloud Fuzziness",  Range(-5, 5)) = 0.04
        
        [Space(5)]
        [Header(Horizon)]
        _HorizonHeight("Horizon Height", Range(-10,10)) = 10
		_HorizonIntensity("Horizon Intensity",  Range(0, 100)) = 3.3
        
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog
            #pragma shader_feature ADDCLOUD

            #include "UnityCG.cginc"

            float4 _BaseColor;

            float _SunSize;
            float _SunInnerBoundary;
            float _SunOuterBoundary;
            float4 _SunColor;
            float4 _MoonColor;

            float _MoonOffset;
            float _MoonSize;

            float4 _DayBottomColor;
            float4 _DayMidColor;
            float4 _DayTopColor;
            float4 _NightBottomColor;
            float4 _NightMidColor;
            float4 _NightTopColor;

            float _StarSpeed;
            float _StarsCutoff;

            float _CloudSpeed;
            float _CloudCutoff;
            float _CloudScale;
            float _CloudColorDay;
            float _CloudColorNight;
            float4 _CloudBrightnessDay;
            float4 _CloudBrightnessNight;
            float4 _CloudColorDaySec;
            float4 _CloudColorNightSec;

            float _DistortSpeed;
            float _DistortScale;

            float _Fuzziness;

            float _HorizonIntensity;
            float _HorizonHeight;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float3 uv : TEXCOORD0;
                float4 pos : SV_POSITION;
                float3 worldPos : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _StarTex;
            float4 _StarTex_ST;
            sampler2D _StarNoiseTex;
            float4 _StarNoiseTex_ST;
            sampler2D _CloudTex;
            float4 _CloudTex_ST;
            sampler2D _DistortTex;
            float4 _DistortTex_ST;
            

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv.xy);

                //float3 worldPos = normalize(i.worldPos);

                //sun
                float sunDist = distance(i.uv.xyz,_WorldSpaceLightPos0);
                float sunArea = saturate((1 - sunDist / _SunSize) * 50);
                sunArea = smoothstep(_SunInnerBoundary,_SunOuterBoundary,sunArea);

                //moon
                float moon = distance(i.uv.xyz,-_WorldSpaceLightPos0);
                float moonDist = saturate((1 - moon / _MoonSize) * 50);
                
                float crescent = distance(float3(i.uv.x + _MoonOffset,i.uv.yz),-_WorldSpaceLightPos0);//crescent新月
                float crescentDist = saturate((1 - crescent / _MoonSize) * 50);

                moonDist = saturate(moonDist - crescentDist);

                float sunNightStep = smoothstep(-0.3,0.25,_WorldSpaceLightPos0.y);
                //DAY NIGHT
                float sky = 1;
                float3 gradientDay = lerp(_DayBottomColor,_DayTopColor,saturate(i.uv.y));
                float3 gradientNight = lerp(_NightBottomColor,_NightTopColor,saturate(i.uv.y));
                float3 skyGradient = lerp(gradientNight,gradientDay,saturate(_WorldSpaceLightPos0.y));

                 float2 skyUV = i.worldPos.xz / clamp(i.worldPos.y,0,10000);
                //STAR
                float3 starTex = tex2D(_StarTex,skyUV + float2(_StarSpeed,_StarSpeed) * _Time.x);
                float3 stars = step(_StarsCutoff,starTex);

                //CLOUD
                /*
                float3 cloud = tex2D(_CloudTex, (skyUV + float2(_Time.x, _CloudSpeed)) * _CloudScale);
                //cloud = step(_CloudCutoff,cloud) + 0.2;

                float distort = tex2D(_DistortTex,(skyUV + float2(_Time.x, _DistortSpeed)) * _DistortScale);
                float noise = tex2D(_DistortTex,(skyUV + distort - _Time.x * _CloudSpeed) * _DistortScale);
                float finalNoise = saturate(noise) * 3 * saturate(i.worldPos.y);
                cloud = saturate(smoothstep(_CloudCutoff * cloud, _CloudCutoff * cloud + _Fuzziness,finalNoise));
                float cloudSec = saturate(smoothstep(_CloudCutoff * cloud, _CloudCutoff * cloud + _Fuzziness,finalNoise));
                float3 cloudColorDay =  (cloud+cloudSec) * _CloudColorDay * _CloudBrightnessDay;
                float3 cloudColorNight = (cloud+cloudSec) * _CloudColorNight * _CloudBrightnessNight;

                float3 finalcloud = lerp(cloudColorNight,cloudColorDay, saturate(_WorldSpaceLightPos0.y));*/
                float2 skyuv = (i.worldPos.xz) / (clamp(i.worldPos.y, 0, 10000));
                float cloud = tex2D(_CloudTex, (skyuv + (_Time.x * _CloudSpeed)) * _CloudScale);
				float distort = tex2D(_DistortTex, (skyuv + (_Time.x * _CloudSpeed)) * _DistortScale);
				float noise = tex2D(_DistortTex, ((skyuv + distort) - (_Time.x * _CloudSpeed)) * _DistortScale);
				float finalNoise = saturate(noise) * 3 * saturate(i.worldPos.y);
				cloud = saturate(smoothstep(_CloudCutoff * cloud, _CloudCutoff * cloud + _Fuzziness, finalNoise));
				float cloudSec = saturate(smoothstep(_CloudCutoff * cloud, _CloudCutoff * cloud + _Fuzziness, finalNoise));
				
				float3 cloudColoredDay = cloud *  _CloudColorDay * _CloudBrightnessDay;
				float3 cloudSecColoredDay = cloudSec * _CloudColorDaySec * _CloudBrightnessDay;
				cloudColoredDay += cloudSecColoredDay;

				float3 cloudColoredNight = cloud * _CloudColorNight * _CloudBrightnessNight;
				float3 cloudSecColoredNight = cloudSec * _CloudColorNightSec * _CloudBrightnessNight;
				cloudColoredNight += cloudSecColoredNight;

				float3 finalcloud = lerp(cloudColoredNight, cloudColoredDay, saturate(_WorldSpaceLightPos0.y));
                /*
                float4 starTex = tex2D(_StarTex,i.uv.xz * _StarTex_ST.xy + _StarTex_ST.zw);
                float4 starNoiseTex = tex3D(_StarNoiseTex,i.uv.xyz * _StarNoiseTex_ST.X + _Time.x * 0.12);

                float starPos = smoothstep(0.21,0.31,starTex.r);
                float starBright = smoothstep(0.613,0.713,starNoiseTex.r);

                float starColor = starPos * starBright;*/

                //horizon
                float3 horizon = abs((i.uv.y * _HorizonIntensity) - _HorizonHeight);
                

                float3 final = (moonDist * _MoonColor + sunArea * _SunColor).rgb
                    + sky * skyGradient 
                    + stars
                    + cloud;
      
                return float4(final,1);
            }
            ENDCG
        }
    }
}
