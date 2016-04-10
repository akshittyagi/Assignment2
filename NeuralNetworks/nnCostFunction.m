function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%
s=0;
    
for i=1:m
    yi=zeros(num_labels,1);
    temp=[1 X(i,:)];
    a2=sigmoid(Theta1*temp');
    a2=[1 a2'];
    a2=a2';
    a3=sigmoid(Theta2*a2);
    h=a3;
    
    num=y(i);
    
    yi(num)=1;
    
    S1=-sum(yi.*log(h));
    S2=-sum((1-yi).*log(1-h));
    s=s+S1+S2;
end

J=J+s/m;

temp1=Theta1.^2;
temp2=Theta2.^2;

s1=0;
s2=0;

for i=1:size(temp1,1)
    for j=2:size(temp1,2)
        s1=s1+temp1(i,j);
    end
end

for i=1:size(temp2,1)
    for j=2:size(temp2,2)
        s2=s2+temp2(i,j);
    end
end

J=J+(lambda/(2*m))*(s1+s2);

% -------------------------------------------------------------
%%%%%%%%%%%%% J computed %%%%%%%%%%%
%%%%%%%%%%%%% Computing Grads %%%%%
cDelta1=zeros(size(Theta1));
cDelta2=zeros(size(Theta2));
for i=1:m
    a1=X(i,:);
    a1=[1 a1];
    z2=(Theta1*a1');
    a2=sigmoid(z2);
    a2=[1 a2'];
    z3=Theta2*a2';
    a3=sigmoid(z3);
    
    yi=zeros(num_labels,1);
    num=y(i);
    yi(num)=1;
    delta3=a3-yi;
    tempTheta2=Theta2(:,2:end);
    delta2=((tempTheta2)'*delta3).*sigmoidGradient(z2);
    %
    cDelta1=cDelta1+delta2*(a1);
    
    cDelta2=cDelta2+delta3*(a2);
end

Theta1_grad=cDelta1/m;
Theta2_grad=cDelta2/m;

t1=Theta1;
t2=Theta2;

for i=1:size(t1,1)
    t1(i,1)=0;
end

for i=1:size(t2,1)
    t2(i,1)=0;
end

t1=t1*lambda/m;
t2=t2*lambda/m;
Theta1_grad=Theta1_grad+t1;
Theta2_grad=Theta2_grad+t2;
% =========================================================================




% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
