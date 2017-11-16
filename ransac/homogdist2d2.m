function [Hnew,inliers,d1,dpts] = homogdist2d2(H, x, th1, th2, T12, type)

if (strcmp('LP', type));i=2;else i=1;end
Hnew=[];
for i=1:i
    % This is based on line end-points
    T1 = T12(1:3,:);      
    T2 = T12(4:6,:);
    Hm  = T2\H(i*3-2:i*3,:)*T1;
    
    x1 = x(1:6,:);   % Extract x1 and x2 from x
    x2 = x(7:12,:);   

    x1 = [ T1\x1(1:3,:); T1\x1(4:6,:)];
    x2 = [ T2\x2(1:3,:); T2\x2(4:6,:)];

    % Calculate, in both directions, the transfered points    
    % (l1, l2) lines used to compute H
%     Hm./Hm(3,3)

    Hx1    = [Hm*x1(1:3,:); Hm*x1(4:6,:)];
    invHx2 = [(Hm)\x2(1:3,:); (Hm)\x2(4:6,:)] ;

    Hx1    = hnormalise(Hx1);
    invHx2 = hnormalise(invHx2); 
    
    
    % Transformed Line equations  using H: lines could be those used to
    % compute H (l1,l2), or lines computed from transformed points (L1,L2)
    

    % difference in x,y coordinates (not orthognal distance)
    dpt1=sum(sqrt((x1([1 2 4 5],:)- invHx2([1 2 4 5],:)).^2),1);
    dpt2=sum(sqrt((x2([1 2 4 5],:)-    Hx1([1 2 4 5],:)).^2),1);
    [dpt1;dpt2];
    dpts=(dpt1 + dpt2);

    % Point-to-line disatnce: 1st-form of distance error estimation (using
    % lines computed from points [before they been transformed] then apply
    % tranformation to lines using computed H L1<--->L2)
    L1    = cross(x1(1:3,:), x1(4:6,:));
    L2    = cross(x2(1:3,:), x2(4:6,:));
    L1    = hnormalise(L1);
    L2    = hnormalise(L2);
    
    invHtL1    = [(Hm')\L1(1:3,:)];
    HtL2       = [(Hm')*L2(1:3,:)];
    invHtL1    = hnormalise(invHtL1);
    HtL2       = hnormalise(HtL2);

    d11=abs(Distance2D_pt2line(invHx2(1:3,:),invHx2(4:6,:),HtL2,x1(1:3,:),3));
    d12=abs(Distance2D_pt2line(invHx2(1:3,:),invHx2(4:6,:),HtL2,x1(4:6,:),3));
    d13=abs(Distance2D_pt2line(Hx1(1:3,:),Hx1(4:6,:),invHtL1,x2(1:3,:),3));
    d14=abs(Distance2D_pt2line(Hx1(1:3,:),Hx1(4:6,:),invHtL1,x2(4:6,:),3));
    [d11;d12;d13;d14];
    d1=max([d11;d12;d13;d14]);
%     inliers = find(dpts<th2);
    inliers = find((d1<th1) & ((dpts)<th2));
    %%
%     % Point-to-line disatnce: 2nd-form of distance error estimation (using
%     % lines computed from points [after they been transformed in both
%     % directions x1<--->x2] )
%     Lx1    = cross(invHx2(1:3,:), invHx2(4:6,:));
%     Lx2    = cross(Hx1(1:3,:), Hx1(4:6,:));
%     
%     Lx1    = hnormalise(Lx1);
%     Lx2    = hnormalise(Lx2);
%     
%     d21=abs(Distance2D_pt2line(invHx2(1:3,:),invHx2(4:6,:),Lx1,x1(1:3,:),3));
%     d22=abs(Distance2D_pt2line(invHx2(1:3,:),invHx2(4:6,:),Lx1,x1(4:6,:),3));
%     d23=abs(Distance2D_pt2line(Hx1(1:3,:),Hx1(4:6,:),Lx2,x2(1:3,:),3));
%     d24=abs(Distance2D_pt2line(Hx1(1:3,:),Hx1(4:6,:),Lx2,x2(4:6,:),3));
%     [d21;d22;d23;d24]
%     d2=max([d21;d22;d23;d24]);
%%
Hnew=[Hnew;Hm];

end


end