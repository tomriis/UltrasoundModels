function rpp = focus_trans_rot(r_obs, r0, e_euler, dr)
% Translates r_obs by r0 and rotates using Euler angles (theta, psi, phi)
% Dr indicates a forward rotation or an inverse rotation
% Theta (pitch) rotates about Y - axis
% Psi (roll) rotates about X - axis
% Phi (yaw) rotates about Z -axis
% dr = direction 1 (forward : element to lab)
%               not 1 (inverse : lab to element)
% Returns a nobs by 3 matrix rpp (same size as input r_obs)

% James  F. Kelly
% 8 July 2006

rpp = zeros(size(r_obs));

theta = e_euler(1);
psi = e_euler(2);
phi = e_euler(3);

costheta = cos(theta);
sintheta = sin(theta);
cospsi = cos(psi);
sinpsi = sin(psi);
cosphi = cos(phi);
sinphi = sin(phi);

A = zeros(3);                  %Forward rotation matrix

A(1,1)= cosphi*costheta-sinphi*sinpsi*sintheta;
A(2,1)= sinphi*costheta+cosphi*sinpsi*sintheta;
A(3,1)= -cospsi*sintheta;
A(1,2)=  -sinphi*cospsi;
A(2,2)= cosphi*cospsi;
A(3,2)= sinpsi;
A(1,3)= cosphi*sintheta+sinphi*sinpsi*costheta;
A(2,3)= sinphi*sintheta-cosphi*sinpsi*costheta;
A(3,3)= cospsi*costheta;
nobs = size(r_obs,1);
B = A';

if (dr == 1)
    for iobs = 1:nobs
 %         rpp(iobs,:) = (B*r_obs(iobs,:)' + r0'  );
         rpp(iobs,:) = (A*r_obs(iobs,:)' + r0'  );

    end
else
    for iobs = 1:nobs
        rp  = r_obs(iobs,:) - r0;
%     rpp(iobs,:) = (A*rp')';
        rpp(iobs,:) = (B*rp')';

    end
end    
