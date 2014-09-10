function [global_best_position global_best_fitness]= myPSO(imgGrey, Img, coef, iter, cc)

% Initialization
n = size (cc ,1);            % Size of the swarm " no of birds "
dim =size (cc ,2);           % Dimension of the problem
iteration = iter;            % Maximum number of "birds steps"

c2 =coef(3);        % PSO parameter C1
c1 = coef(2);       % PSO parameter C2
cns =coef(1);       % pso momentum or inertia
% fitness=zeros(n,iteration);

%-----------------------------%
%    initialize the parameter %
%-----------------------------%

R1 = rand(dim, n);
R2 = rand(dim, n);
current_fitness = zeros(n,1);

current_position = cc';
velocity = randn(dim,n) ;
local_best_position  = current_position ;
globl_best_position= zeros(dim,n);


for i = 1:n
    temp = (fit_ness(imgGrey,Img,current_position(:,i)));
    current_fitness(i)=temp;   
%     if temp ==Inf
%             current_fitness(i) = 0;
%         else
%             current_fitness(i)=temp;
%         end
end


local_best_fitness  = current_fitness;
[global_best_fitness,g] = min(local_best_fitness) ;

for i=1:n
    globl_best_position(:,i) = local_best_position(:,g);
end
% velocity = cns *(velocity + c1*(R1.*(local_best_position-current_position)) + c2*(R2.*(globl_best_position-current_position)));
% 
% %------------------%
% %   SWARMUPDATE    %
% %------------------%
% 
% 
% current_position(3,:)
% current_position = current_position + velocity ;
% current_position = [round(current_position(1,:)); abs(current_position(2,:)); round(current_position(3,:))] ;
current_position = [abs(round(current_position(1,:))); abs(current_position(2,:)); abs(round(current_position(3,:)))] ;
%     
%     if (round(current_position(3,:))>511) | (current_position(1,:)>150) | (current_position(2,:)>1) 
%         current_position(3,:)
%         display('First update');
%         current_position(3,:)
%         current_position(1,:)=45;
%         current_position(3,:)=250;
%         current_position(2,:)=0.5; 
%     end
%% Main Loop


iter = 0 ;

while  ( iter < iteration )
    iter = iter + 1;
    disp(iter)
    for i = 1:n
        temp = (fit_ness(imgGrey, Img,current_position(:,i)));

        current_fitness(i)=temp;
%         if temp ==Inf
%             current_fitness(i) = 0;
%         else
%             current_fitness(i)=temp;
%         end
    end
    
    
    for i = 1 : n
        if current_fitness(i) < local_best_fitness(i)
            local_best_fitness(i)  = current_fitness(i);
            local_best_position(:,i) = current_position(:,i);
        end
    end
    
    
    [current_global_best_fitness,g] = min(local_best_fitness);
    
    
    if (current_global_best_fitness < global_best_fitness)
        global_best_fitness = current_global_best_fitness
        
        for i=1:n
            globl_best_position(:,i) = local_best_position(:,g);
        end
        
    end
    
    % Global fitness values
    global_best_fitness
    k=globl_best_position(:,1)
    
    
    velocity = cns *(velocity + c1*(R1.*(local_best_position-current_position)) + c2*(R2.*(globl_best_position-current_position)));
    current_position = current_position + velocity;
    current_position = [abs(round(current_position(1,:))); abs(current_position(2,:)); abs(round(current_position(3,:)))] ;
    
    if (round(current_position(3,:))>511) | (current_position(1,:)>150) | (current_position(2,:)>1) 
        current_position(1,:)=45;
        current_position(3,:)=250;
        current_position(2,:)=0.5; 
    end
    % x=current_position(1,:);
    % y=current_position(2,:);
    
    % clf
    %     plot(x, y , 'h')
    %     axis([-10 10 -10 10]);
    %
    % pause(.2)
    
    
end % end of while loop its mean the end of all step that the birds move it

global_best_position = globl_best_position(:,1);


