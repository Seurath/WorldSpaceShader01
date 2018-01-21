// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "WorldSpaceDissolve"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_DissolveTex("DissolveTex", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 2.0
		#pragma surface surf Standard keepalpha noshadow exclude_path:deferred 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform sampler2D _DissolveTex;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float2 uv_TexCoord94 = i.uv_texcoord * ase_worldPos.xy + float2( 0,0 );
			o.Albedo = float3( uv_TexCoord94 ,  0.0 );
			o.Alpha = 1;
			clip( ( distance( ase_worldPos , _WorldSpaceCameraPos ) * (float4( 0.4926471,0.4926471,0.4926471,0 ) + (tex2D( _DissolveTex, uv_TexCoord94 ) - float4( 0,0,0,0 )) * (float4( 1,1,1,0 ) - float4( 0.4926471,0.4926471,0.4926471,0 )) / (float4( 1,1,1,0 ) - float4( 0,0,0,0 ))) ).r - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14201
243;94;880;713;1899.444;761.8793;2.625612;True;False
Node;AmplifyShaderEditor.CommentaryNode;21;-1303.7,119.9339;Float;False;1296.346;797.877;Cutoff;3;7;1;93;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;1;-1177.742,186.0489;Float;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;94;-1039.047,-180.7531;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;22;-796.0695,-285.9288;Float;True;Property;_DissolveTex;DissolveTex;2;0;Create;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldSpaceCameraPos;93;-1200.108,468.4506;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TFHCRemapNode;83;-440.4913,-278.7133;Float;False;5;0;COLOR;0.0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;3;COLOR;0.4926471,0.4926471,0.4926471,0;False;4;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DistanceOpNode;7;-905.0843,368.8539;Float;False;2;0;FLOAT3;0.0,0,0,0;False;1;FLOAT3;0.0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-126.8179,-432.825;Float;True;Property;_MainTex;MainTex;1;0;Create;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;65;-800.4097,-540.286;Float;True;Property;_DissolvePercentage;DissolvePercentage;3;0;Create;1;0.1;0.5;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-96.48351,-132.3937;Float;False;2;2;0;FLOAT;0,0,0,0;False;1;COLOR;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;300.5442,-176.6084;Float;False;True;0;Float;ASEMaterialInspector;0;0;Standard;WorldSpaceDissolve;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;0;False;0;0;Custom;0.5;True;False;0;True;TransparentCutout;Geometry;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;False;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Absolute;0;;0;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;94;0;1;0
WireConnection;22;1;94;0
WireConnection;83;0;22;0
WireConnection;7;0;1;0
WireConnection;7;1;93;0
WireConnection;90;0;7;0
WireConnection;90;1;83;0
WireConnection;0;0;94;0
WireConnection;0;10;90;0
ASEEND*/
//CHKSM=BB45A4DFF3AAB5C080B68619E287C3E5BBD49C1B