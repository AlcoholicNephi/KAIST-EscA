function [Jacobian] = Gradient_Solver(iParameters, Junc, Component, Mechanics, Condition)

Parameters = iParameters.name;

[f0] = Build_f(Junc, Condition, Component, Mechanics);

[f_p] = Build_fp(Condition, Junc, Mechanics, Component, Parameters, f0);

[g0] = get_g(Condition, Junc, Component);

[g_p] = Build_gp(Condition, Junc, Parameters, Mechanics, Component, g0);

[g_x] = Build_gx(Condition, Junc, Component, g0);

[f_x] = Build_fx(Junc, Condition, Component, Mechanics);

lambda = transpose(f_x) \ transpose(g_x);

Jacobian = g_p - transpose(lambda) * f_p;


end

