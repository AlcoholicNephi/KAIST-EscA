function [ Jacobian, Hessian ] = Adjoint_Solver(iParameters, Junc, Component, Mechanics, Condition)

Parameters = iParameters.name;

Num_junc = size(Junc, 2);

%%% Functions

% [Junc(1).T, Junc(2).T ... Junc(12).T, Junc(1).P, ..., Junc(12).P]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[f0] = Build_f(Junc, Condition, Component, Mechanics);
[g0] = get_g(Condition, Junc, Component);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Build f_x, g_x

[f_x] = Build_fx(Junc, Condition, Component, Mechanics);
[g_x] = Build_gx(Condition, Junc, Component, g0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Build f_p, g_p

[f_p] = Build_fp(Condition, Junc, Mechanics, Component, Parameters, f0);
[g_p] = Build_gp(Condition, Junc, Parameters, Mechanics, Component, g0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Build Jacobian

% inv_f = inv(transpose(f_x)); % Áß¿ä!

inv_f = inv(transpose(f_x));

lambda_0 = inv_f * transpose(g_x);

Jacobian = g_p - transpose(lambda_0) * f_p;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Build g_pp, f_pp, f_xp, f_px

for i=1:size(Parameters, 2)
    
    eval(['delta = ', Parameters{i}, ' *  Condition.delt;'])
    eval([Parameters{i}, ' = ', Parameters{i}, ' + delta;'])
    
    [f00] = Build_f(Junc, Condition, Component, Mechanics);
    [g00] = get_g(Condition, Junc, Component);
    
    g_pp(i, :) = (Build_gp(Condition, Junc, Parameters, Mechanics, Component, g00) - g_p)/delta;
    f_pp(:, :, i) = (Build_fp(Condition, Junc, Mechanics, Component, Parameters, f00) - f_p)/delta;
    f_xp(:, :, i) = (Build_fx(Junc, Condition, Component, Mechanics) - f_x)/delta;
    
    eval([Parameters{i}, ' = ', Parameters{i}, ' - delta;'])
    
end

for i=1:size(f_xp, 2)
    for j=1:size(Parameters, 2)
        f_px(:, j, i) = f_xp(:, i, j);
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Build g_px, g_xx, f_xx


for i=1:Num_junc %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    delT = Junc(i).T * Condition.delt;
    delP = Junc(i).P * Condition.delt;
    
    iJunc = Junc;
    iJunc(i).T = iJunc(i).T + delT;
    
    iiJunc = Junc;
    iiJunc(i).P = iiJunc(i).P + delP;
    
    g0T = get_g(Condition, iJunc, Component);
    g0P = get_g(Condition, iiJunc, Component);
    
    g_px(i + Num_junc, :) = (Build_gp(Condition, iJunc, Parameters, Mechanics, Component, g0T) - g_p)/delT;
    g_px(i, :) = (Build_gp(Condition, iiJunc, Parameters, Mechanics, Component, g0P) - g_p)/delP;
    
    g_xx(i + Num_junc, :) = (Build_gx(Condition, iJunc, Component, g0T) - g_x)/delT;
    g_xx(i, :) = (Build_gx(Condition, iiJunc, Component, g0P) - g_x)/delP;
    
end

[f_xx] = Build_fxx(Junc, Condition, Component, Mechanics);

lambda_1 = inv_f * g_px;
lambda_2 = inv_f * g_xx;
lambda_3 = inv_f * (-1 * transpose(lambda_2) * f_p);

x_p = -1 * transpose(inv_f) * f_p;


Hessian = g_pp - transpose(lambda_1) * f_p - transpose(f_p) * lambda_1 - transpose(lambda_3) * f_p;

sum1 = zeros(size(f_px, 1), size(Parameters, 2), size(Parameters, 2));
sum2 = zeros(size(f_xx, 1), size(f_xx, 1), size(Parameters, 2));

for i=1:size(Parameters, 2)
    
    for j=1:2*Num_junc
        sum1(:, :, i) = sum1(:, :, i) + f_px(:, :, j) * x_p(j, i);
        sum2(:, :, i) = sum2(:, :, i) + f_xx(:, :, j) * x_p(j, i);
    end
    
    Hessian(i, :) = Hessian(i, :) - transpose(lambda_0) * ( f_pp(:, :, i) + sum1(:, :, i) + (f_xp(:, :, i) + sum2(:, :, i)) * x_p );
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

