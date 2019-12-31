function Twc = PoseInv(Tcw)
    Twc = eye(4);
	Twc(1:3,1:3) =  Tcw(1:3,1:3)';
	Twc(1:3,4)   = -Tcw(1:3,1:3)'*Tcw(1:3,4);
end