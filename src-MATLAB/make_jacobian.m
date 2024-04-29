function J_matrix = make_jacobian(T_latent, T_infectious, beta, N, log10_I0)
%MAKE_JACOBIAN Summary of this function goes here
%   Detailed explanation goes here

% NOTE:
% beta = c * q * sigma;

I0 = 10^(log10_I0);

S0 = N - I0;

gamma1 = 2 / T_latent;
gamma2 = 2 / T_infectious;

J_matrix = [0, 0, 0, -beta*S0, -beta*S0, 0;
            0, -gamma1, 0, beta*S0, beta*S0, 0;
            0, gamma1, -gamma1, 0, 0, 0;
            0, 0, gamma1, -gamma2, 0, 0;
            0, 0, 0, gamma2, -gamma2, 0;
            0, 0, 0, 0, gamma2, 0];
end

