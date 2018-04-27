function  [ yTest, Time ] = PSVM( xTrain, yTrain, xTest, opts )
%PSVM �˴���ʾ�йش˺�����ժҪ
% Proximal Support Vector Machine
%   �˴���ʾ��ϸ˵��

%% Parse opts
nu = opts.nu;
kernel = opts.kernel;

%% Fit
tic;
X = xTrain;
Y = yTrain;
H = Kernel(X, X, kernel);
Q = Y.*(H + 1).*Y';
I = speye(size(H));
e = ones(size(Y));
Alpha = Cond(Q + 1/nu*I)\e;
svi = (Alpha>0)&(Alpha<nu);
b = Y(svi,:)'*Alpha(svi,:);
Time = toc;

%% Predict
yTest = sign(Kernel(xTest, X(svi,:), kernel)*(Y(svi,:).*Alpha(svi,:)) + b);
yTest(yTest==0) = 1;

end

