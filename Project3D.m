function [newpoint,invzc] = Project3D(RT,cameraParams,MPpoint)
    P3 = MPpoint;
    P3(:,4) = 1;
    P3 = P3';
    RT = RT(1:3,1:4);
    newpoint = RT*P3;
    invzc = 1./newpoint(3,:);
    newpoint = cameraParams*newpoint;
    newpoint = newpoint./repmat(newpoint(3,:),3,1);
    newpoint = newpoint(1:2,:)';
end
