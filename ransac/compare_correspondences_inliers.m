
function compare_correspondences_inliers(I1,I2,ptAllI1,ptAllI2,H,inliers,w)
% compare detectd inliers & thier projected correspondences using obtained
% Homography
[Psiz,npts]=size(ptAllI1);

if (Psiz)==4
    ptAllI1=[ptAllI1(1:2,:); ones(1,npts);ptAllI1(3:4,:); ones(1,npts)];
    ptAllI2=[ptAllI2(1:2,:); ones(1,npts);ptAllI2(3:4,:); ones(1,npts)];
end

pt1_inliers=ptAllI1(:,inliers);
pt2_inliers=ptAllI2(:,inliers);

% Points from Image 1 ----> to Image 2 ------------------------------------
pt1H_inl=[H*pt1_inliers(1:3,:); H*pt1_inliers(4:6,:)];
pt1Hn_inl= hnormalise(pt1H_inl);
Hinliers_2_I2=pt1Hn_inl([1 2 4 5],:);
[ProjPointsfrom1] = CreatePointsfromProjectedLines(pt1Hn_inl,w);

% Points from Image 2 ----> to Image 1 ------------------------------------
pt2invH_inl=[H\pt2_inliers(1:3,:); H\pt2_inliers(4:6,:)];
pt2invHn_inl= hnormalise(pt2invH_inl);
invHinliers_2_I1=pt2invHn_inl([1 2 4 5],:);
[ProjPointsfrom2] = CreatePointsfromProjectedLines(pt2invHn_inl,w);
%--------------------------------------------------------------------------
% for points to points correspondences
PlotCorrespLines1(I1,I2,[pt1_inliers([1 2 4 5],:) invHinliers_2_I1],[pt2_inliers([1 2 4 5],:) Hinliers_2_I2],inliers)

% for points to Lines correspondences
PlotCorrespLines1(I1,I2,[pt1_inliers([1 2 4 5],:) ProjPointsfrom2([1 2 4 5],:)],[pt2_inliers([1 2 4 5],:) ProjPointsfrom1([1 2 4 5],:)],inliers)
end