// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Vine"
{
	Properties
	{
		_Grow("Grow", Range( -2 , 2)) = 0
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Float0("Float 0", Float) = 1
		_Expand("Expand", Range( -2 , 1)) = 0
		_GrowMax("GrowMax", Range( 0 , 1)) = 0
		_GrowMin("GrowMin", Range( 0 , 1)) = 0
		_EndMin("EndMin", Range( 0 , 1)) = 0
		_EndMax("EndMax", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _Expand;
		uniform float _Float0;
		uniform float _GrowMin;
		uniform float _GrowMax;
		uniform float _Grow;
		uniform float _EndMin;
		uniform float _EndMax;
		uniform float _Cutoff = 0.5;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float temp_output_6_0 = ( v.texcoord.xy.y - _Grow );
			float smoothstepResult8 = smoothstep( _GrowMin , _GrowMax , temp_output_6_0);
			v.vertex.xyz += ( ase_vertexNormal * _Expand * _Float0 * smoothstepResult8 );
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float temp_output_6_0 = ( i.uv_texcoord.y - _Grow );
			float smoothstepResult8 = smoothstep( _GrowMin , _GrowMax , temp_output_6_0);
			float smoothstepResult12 = smoothstep( _EndMin , _EndMax , i.uv_texcoord.y);
			float3 temp_cast_0 = (max( smoothstepResult8 , smoothstepResult12 )).xxx;
			o.Emission = temp_cast_0;
			o.Alpha = 1;
			clip( temp_output_6_0 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
0;73.6;1536;711.8;945.2716;254.3551;1;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-447.5008,-400.4531;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;7;-497.1296,-256.7874;Inherit;False;Property;_Grow;Grow;0;0;Create;True;0;0;0;False;0;False;0;0;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;6;-175.1297,-279.7875;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-465.1597,54.63969;Inherit;False;Property;_GrowMax;GrowMax;4;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-462.1597,-25.36032;Inherit;False;Property;_GrowMin;GrowMin;5;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-413.4119,524.5689;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;13;-445.6006,682.9857;Inherit;False;Property;_EndMin;EndMin;6;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-448.6006,777.9857;Inherit;False;Property;_EndMax;EndMax;7;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;8;-49.15967,-12.36031;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-460.9582,391.0339;Inherit;False;Property;_Float0;Float 0;2;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;2;-475.4671,154.2374;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-481.2672,301.3378;Inherit;False;Property;_Expand;Expand;3;0;Create;True;0;0;0;False;0;False;0;0;-2;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;12;-138.6006,587.9857;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-5.266998,208.3374;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;15;151.601,70.09376;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;287.513,-235.3691;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Vine;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Opaque;;AlphaTest;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;1;2
WireConnection;6;1;7;0
WireConnection;8;0;6;0
WireConnection;8;1;10;0
WireConnection;8;2;9;0
WireConnection;12;0;11;2
WireConnection;12;1;13;0
WireConnection;12;2;14;0
WireConnection;3;0;2;0
WireConnection;3;1;4;0
WireConnection;3;2;5;0
WireConnection;3;3;8;0
WireConnection;15;0;8;0
WireConnection;15;1;12;0
WireConnection;0;2;15;0
WireConnection;0;10;6;0
WireConnection;0;11;3;0
ASEEND*/
//CHKSM=22F6A9B0F6645F568A865D21ADB83C4823F5250A