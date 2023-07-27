% =================================================
%       Main Code - Rastrigin Function
%       Foad Moslem (foad.moslem@gmail.com) - Researcher | Aerodynamics
%       Using MATLAB R2022a
% =================================================
clc; clear; close all;

% Function Alignment Lines (2D) =========================
[X1, Y1] = meshgrid(linspace(-5, 5, 101), linspace(-5, 5, 101));
for i = 1:length(X1)
    for j = 1:length(Y1)
        Z(i, j) = ObjFunc([X1(i,j), Y1(i,j)]);
    end
end
contour(X1, Y1, Z, 20)
axis([-5, 5, -5, 5])
hold on

% Main Code - Rastrigin Function =========================
global numFunc;
numFunc = 0;
tic
Iter = 0;

% Initial Values
epsilon = 0.0001;

X_optArray = [];
fval_optArray = [];

fun = 'ObjFunc';
A = []; 
B = []; 
Aeq = []; 
Beq = []; 
lb = [];
ub = []; 
% nonlcon = [];
nonlcon = 'constraints';

% options = optimoptions('fmincon', 'OutputFcn','outfun');
options = optimoptions('fmincon', 'OutputFcn','outfun', 'Display','off', 'Algorithm','active-set');
        % OutputFcn: Specify one or more user-defined functions that an optimization function calls at each iteration.
        % Specified user-defined function: 'outfun'

% X0 = [4, 4];
% Find an Initial Feasible Point (X0) by Random Serach Method
a = -5; % Min value for random number generation
b = 5; % Max value for random number generation
x1 = (b-a).*rand + a;
x2 = (b-a).*rand + a;
X0 = [x1, x2];
[c, ceq] = constraints(X0);
while any(c > 0) || any (ceq ~= 0)
    x1 = (b-a).*rand + a;
    x2 = (b-a).*rand + a;
    X0 = [x1, x2];
    [c, ceq] = constraints(X0);
end
fval_X0 = ObjFunc(X0);

[X_opt, fval_opt, exitflag, output, history] = fmincon(fun, X0, A, B, Aeq, Beq, lb, ub, nonlcon, options);
plot(X_opt(:,1), X_opt(:,2), 'kx', 'LineWidth', 1);

for Iter = 1:13
%while (abs((fval_opt - fval_X0) / fval_opt) > epsilon) 
    X_optArray = [X_optArray; X_opt];
    fval_optArray = [fval_optArray; fval_opt];
    
    X0 = X_opt *rand;
    fval_X0 = ObjFunc(X0);
    
    [X_opt, fval_opt, exitflag, output, history] = fmincon(fun, X0, A, B, Aeq, Beq, lb, ub, nonlcon, options);
    plot(X_opt(:,1), X_opt(:,2), 'kx', 'LineWidth', 1);
    Iter = Iter+1;
end
[fval_opt, I] = min(fval_optArray);
X_opt = X_optArray(I, :);

% =====================================
fprintf('Iter: %2.0f\n', Iter)
fprintf('Number of CallFunction: %6.f\n',numFunc)
fprintf('CPU time: %6.4f\n',toc)
fprintf('X(1) Value of Optimum Point: %6.4f\n',X_opt(:,1))
fprintf('X(2) Value of Optimum Point: %6.4f\n',X_opt(:,2))
fprintf('Function Value of Optimum Point: %6.4f\n',fval_opt)

% p = gca;
% exportgraphics(p, 'Plot.png','Resolution',300)
% 
%results(Iter,:) = table(Iter, numFunc, toc, X_opt(:,1), X_opt(:,2), fval_opt);
% writetable(results, 'Main_RastriginFunction.xlsx', 'Sheet', 1);


