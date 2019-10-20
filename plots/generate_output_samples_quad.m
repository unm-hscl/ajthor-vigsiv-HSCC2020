function Ys = generate_output_samples_quad(Xs,Us,Ts,dtype)

rng(0);

m = 5; 
r = 2;
I = 2;
g = 9.81;

    if dtype == 1
        Ys(1,:) = Xs(1,:) + Ts*Xs(2,:) + 1E-3*randn(1,size(Xs,2));
        Ys(2,:) = -Ts/m*sin(Xs(3,:)).*(Us(1,:)+Us(2,:)) + Xs(2,:) + 1E-5*randn(1,size(Xs,2));
        Ys(3,:) = Xs(3,:) + Ts*Xs(4,:)+ 1E-3*randn(1,size(Xs,2));
        Ys(4,:) = Ts/m*cos(Xs(3,:)).*(Us(1,:)+Us(2,:)) - Ts/g + Xs(4,:) + 1E-5*randn(1,size(Xs,2));
        Ys(5,:) = Xs(5,:) + Ts*Xs(6,:) + 1E-3*randn(1,size(Xs,2));
        Ys(6,:) = Ts*r/I.*(Us(1,:)-Us(2,:)) + Xs(6,:) + 1E-5*randn(1,size(Xs,2));
    elseif dtype == 2
        Ys(1,:) = Xs(1,:) + Ts*Xs(2,:) + 0.1*betarnd(1,0.5,1,size(Xs,2));
        Ys(2,:) = -Ts/m*sin(Xs(3,:)).*(Us(1,:)+Us(2,:)) + Xs(2,:) + 0.1*betarnd(1,0.5,1,size(Xs,2));
        Ys(3,:) = Xs(3,:) + Ts*Xs(4,:)+ 0.1*betarnd(1,0.5,1,size(Xs,2));
        Ys(4,:) = Ts/m*cos(Xs(3,:)).*(Us(1,:)+Us(2,:)) - Ts/g + Xs(4,:) + 0.1*betarnd(1,0.5,1,size(Xs,2));
        Ys(5,:) = Xs(5,:) + Ts*Xs(6,:) + 0.1*betarnd(1,0.5,1,size(Xs,2));
        Ys(6,:) = Ts*r/I.*(Us(1,:)-Us(2,:)) + Xs(6,:) + 0.1*betarnd(1,0.5,1,size(Xs,2));
    end

end
