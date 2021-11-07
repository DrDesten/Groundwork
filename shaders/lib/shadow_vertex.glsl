uniform mat4 shadowModelView;
uniform mat4 shadowProjection;
uniform vec3 shadowLightPosition;

float getShadowBias(float NdotL) {
	return clamp(( sqrt(NdotL * -NdotL + 1) / NdotL ) * (SHADOW_BIAS / shadowMapResolution), 1e-6, 1e6);
}

vec3 getShadowPos(vec3 playerPos) {
	vec3 shadowView = transformMAD(playerPos, shadowModelView);
	vec3 shadowClip = projectOrthographicMAD(shadowView, shadowProjection);
	return shadowClip;
}


/* Derivation of the shadow bias formula

We need the amount that the edge of a shadow texel is inside the surface.
We assume the surface to be flat.

Using this, we can draw a right angle triangle.
One side (submerged) has the length: pixelSize / 2
The other side has the length a, this is what I am trying to find.
The hypothenuse is irrelevant.

NdotL describes the cosine of the angle of the screen space view ray to the normal of the face.
      This Angle is equal to the angle of the pixel plane to the surface.
NdotL = cos(α)

We know that       tan(α) = a / (pixelSize / 2)
We also know that  acos(NdotL) = α

So                 a = tan(acos(NdotL)) * (pixelSize / 2)
a is our shadow bias.

We assume a pixel is circluar
pixelSize = sqrt(2) / shadowMapResolution

The remaining factor has to do with the scale of the depth buffer. To improve performance we can simply tweak that value until it fits, since it should be constant.
Since this, aswell as pixelSize scales linearly, we can combine it. This way pixelSize becomes:

pixelSize = magicValue / shadowMapResolution

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Now, we have another problem: Shadow distortion.

Shadow Distorsion manipulates pixelSize.
Using the derivative of our shadow distorsion function, we can find the modifier to our pixelSize. 
Since a high derivative corresponds to a low pixel size (in world space that is) we have to divide by it.

Since pixelSize scales the bias function linearly we can simply divide the output by it.
To improve performace I multiply it by (1 / derivative), because I can simly flip the fraction for the derivative.

This concludes our function for the shadow bias.
We clamp it to avoid 0 and Infinite values, as those cause errors.

*/