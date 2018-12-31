function out=intersectPlaneSurf(p0, v, exx, eyy, ezz)
% Written by: Mehryar Emambakhsh
% Email: mehryar_emam@yahoo.com
% Date: 31 December 2018
% Paper:
% M. Emambakhsh and A. Evans, “Nasal patches and curves for an expression-robust 3D face recognition,” 
% IEEE Transactions on Pattern Analysis and Machine Intelligence (PAMI), vol. 39, no. 5, pp. 995-1007, 2017. 
% This function is a slightly modified version of OZTURK's code (see below).

%out=intersectPlaneSurf(p0, v, exx, eyy, ezz)
% Intersection points of an arbitrary surface with an arbitrary plane.
% The plane must be specified with "p0" which is a point that plane includes
% and normal vector of the plane "v". "exx", "eyy" and "ezz" is the surface coordinates.
% Mehmet OZTURK - KTU Electrical and Electronics Engineering, Trabzon/Turkey

v=v./norm(v); % normalize the normal vector

mx=v(1); my=v(2); mz=v(3);

% elevation and azimuth angels of the normal of the plane
phi  = acos(mz./sqrt(mx.*mx + my.*my + mz.*mz)); % 0 <= phi <= 180
teta = atan2(my,mx);

st=sin(teta); ct=cos(teta);
sp=sin(phi); cp=cos(phi);

T=[st -ct 0; ct*cp st*cp -sp; ct*sp st*sp cp];
invT=[st ct*cp ct*sp; -ct st*cp st*sp; 0 -sp cp];

% transform surface such that the z axis of the surface coincides with
% plane normal
exx=exx-p0(1); eyy=eyy-p0(2); ezz=ezz-p0(3);
nexx = exx*T(1,1) + eyy*T(1,2) + ezz*T(1,3);
neyy = exx*T(2,1) + eyy*T(2,2) + ezz*T(2,3);
nezz = exx*T(3,1) + eyy*T(3,2) + ezz*T(3,3);

% use MATLABs contour3 algorithm to find the intersections
c=contours(nexx,neyy,nezz,[0 0]);

limit = size(c,2);
i = 1;
ncx=[]; ncy=[];
contours_lengths = [];
contours_starting_index = [];
contours_ending_index = [];
while(i < limit)
  npoints = c(2,i);
  nexti = i+npoints+1;
  contours_lengths = [contours_lengths; npoints];
  contours_starting_index = [contours_starting_index; i+1];
  contours_ending_index = [contours_ending_index; nexti-1];
  i = nexti;

end
% Finding the biggest contour and only save that one
[~, max_ind] = max(contours_lengths);
max_ind = max_ind(1);
my_start_ind = contours_starting_index(max_ind);
my_end_ind = contours_ending_index(max_ind);

ncx = [ncx c(1,my_start_ind:my_end_ind)];
ncy = [ncy c(2,my_start_ind:my_end_ind)];

% inverse transformation of the intersection coordinates 
cx=ncx*invT(1,1) + ncy*invT(1,2) + p0(1);
cy=ncx*invT(2,1) + ncy*invT(2,2) + p0(2);
cz=ncx*invT(3,1) + ncy*invT(3,2) + p0(3);

out=[cx(:) cy(:) cz(:)];
if nargout==0
    fig=surf(exx+p0(1),eyy+p0(2),ezz+p0(3));
    set(fig,'FaceColor',[.8 .8 .8],'EdgeColor','none');
    camlight,daspect([1 1 1]),axis vis3d,lighting gouraud
    hold on,plot3(cx,cy,cz,'Linewidth',3)

    plane=createPlane(p0,v(:).');
    hold on,drawPlane3d(plane)
end
