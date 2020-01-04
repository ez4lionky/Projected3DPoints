function isVisible = isInFrustum(pts_w3d, pts_c3d, pts_c2d, mOw, CosLimit, Normals, psMaxDistance, psMinDistance)
    nums = size(pts_w3d);
    mnMinX = 0; mnMaxX = 640; mnMinY = 0; mnMaxY = 480;
    isVisible = ones(nums(1), 1);

    % Check the depth is positive
    isVisible(pts_c3d(:, 3) < 0) = 0;
    % Check the points projected in image are not outside
    isVisible(pts_c2d(:, 1) < mnMinX | pts_c2d(:, 1) > mnMaxX) = 0;
    isVisible(pts_c2d(:, 2) < mnMinY | pts_c2d(:, 2) > mnMaxY) = 0;
    % Check distance is in the scale invariance region of the MapPoint
    PO = pts_w3d - repmat(mOw, nums(1), 1);
%     dist1 = sum(abs(PO).^2, 2).^(1/2);
%     dist2 = sum(abs(Normals).^2, 2).^(1/2);
    dist = sum(abs(PO).^2, 2).^(1/2);
%     isVisible(dist1 < psMinDistance | dist1 > psMaxDistance) = 0;
    isVisible(dist < psMinDistance | dist > psMaxDistance) = 0;
    % Check viewing angle
%     viewCos = dot(PO, Normals, 2) ./ (dist1 .* dist2);
    viewCos = dot(PO, Normals, 2) ./ dist;
    isVisible(viewCos < CosLimit) = 0;
end