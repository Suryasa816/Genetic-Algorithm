clc
N = input("Enter population size: ");
min_value = 0 ;
max_value =0.5 ;
L = input("Enter length half binary string: ");
max_gen = input("Enter maximum number of generations: ");
prob_crossover = input("Enter cross-over probability: ");
prob_mutation = input("Enter mutation probability: ");
gen =1;
population = randi([0 1],N,2*L) ;%initialsing population of solutions
x= zeros( N,2*L);
generations = [];
Average = [];
max_fit = [];

%assigning solutions string wise
for i= 1:N 
    x(i,1:L) = population(i,1:L);
    x(i,L+1:2*L) = population(i,L+1:2*L);
end 
disp(x);
decodeval_x = zeros(N,2);
%loop for checking
while( gen<max_gen) 
    for i= 1:N 
        sum1= 0;
        sum2= 0;
       %decoding for getting real values 
        exponent = L-1 ; 
        for k= 1:L
        sum1 = sum1+ x(i,k)*2^(exponent);
        exponent= exponent-1;
        end
        decodeval_x(i,1)= sum1;
        for k= L+1:2*L
            sum2= sum2 + x(i,k)*2^(exponent);
            exponent= exponent-1;
        end 
        decodeval_x(i,2) = sum2;
        
        
    end
      
   variable = zeros(N,2);
   for i= 1:N 
       variable(i,1)= min_value + ((max_value-min_value)/(2^L-1))*decodeval_x(i,1) ;
        variable(i,2)= min_value + ((max_value-min_value)/(2^L-1))*decodeval_x(i,2) ;
   end
   fitness_val = zeros(N);
   
  maximum = 0;
   Avg_fitness = 0;
   %finding fitness values and average fitness values
   for i=1:N 
       fitness_val(i)= maximumfunc(variable(i,1),variable(i,2));
       maximum = max(fitness_val(i));
   
        Avg_fitness = Avg_fitness + fitness_val(i) ;
        Avg_fitness = Avg_fitness/N ;
       
   end
   
   max_fit = [max_fit maximum] ;
 
   Average = [Average Avg_fitness];
   
   %mating pool selection using roulette wheel
    prob = fitness_val/sum(fitness_val);    %Probability of fitness    
    prob_Area = 0;                  %Iteration variable
    area = zeros(N,1);              %Area sections in Roulette wheel
    for i = 1:N
        prob_Area = prob_Area + prob(i);
        Area(i) = prob_Area;
    end
    
    %Mating pool selection using Roulette Wheel
    mating_pool = zeros(size(x));
    for i = 1:N
       r = rand(1);   %Rotating Roulette wheel
        for k = 1:N
            if Area(k) >= r
                mating_pool(i,:) = x(k,:);
                break;
            end
        end
    end
    %mating pairs
    mating_pair = zeros(floor(N/2),2);
    if(mod(gen,2) == 0)
        for i= 1:floor(N/2)
            mating_pair(i,1)= i;
            mating_pair(i,2) = 2*i;
        end
    else    
        for i= 1:floor(N/2)
            mating_pair(i,1) = i;
            mating_pair(i,2) = N + 1-i;
        end
    end 
    
        for i= 1: floor(N/2)
            pre_parent1= mating_pair(i,1);
            pre_parent2= mating_pair(i,2);
            
            parent1= mating_pool(pre_parent1,:);
            parent2 = mating_pool(pre_parent2,:);
            child1 =parent1;
            child2 = parent2;
            
     
       if rand(1)<= prob_crossover

            %Random crossover positions
               p1= randi([1 2*L-1],1,1);
               p2 = randi([1 2*L-1],1,1);%1st position
     %2nd position
            if p1 > p2
                start= p2;
                stop = p1;
            else 
                start= p1;
                stop= p2;
            end 
            %cross over 
           temp = child1(1,start:1:stop)    ;
        child1(1,start:stop) = child2(1,start:1:stop);
        child2(1,start:stop) = temp;
       end
       %mutation
    for bit = 1:L
            if(rand(1,1)<prob_mutation)
                if(child1(bit) ==0)
                    child1(bit) = 1;
                else 
                    child1(bit) = 0;
                end
            
                if(child2(bit) ==0)
                    child2(bit) = 1;
                else 
                    child2(bit) = 0;
                end
            end
    end
        
       %updating
    x(2*i -1,:) = child1;
    x(2*i,:) = child2;
        end
       
        gen = gen +1 ;
       %generations matrix
        generations = [generations gen]
end 

    
   for i = 1:N
        %calculating the decoded values
        sum1 =0;
        sum2 =0;
    
        exponent = L-1;
        for k = 1:L
            sum1 = sum1 + x(i,k)*2^exponent;
            exponent = exponent -1;
        end
            decodeval_x(i,1) = sum1; %decoded value 1
   
        exponent = L-1;
        for k = L+1:2*L
            sum2  = sum2  + x(i,k)*2^exponent;
            exponent = exponent -1;
        end
        decodeval_x(i,2) = sum2; %decoded value 2
    end

        val_for_fun = zeros(N,2);
    for i = 1:N
        variable(i,1) = min_value + (max_value - min_value)/(2^L - 1)*decodeval_x(i,1);
        variable(i,2) = min_value + (max_value - min_value)/(2^L - 1)*decodeval_x(i,2);
        
    end
   
    disp(x(:,:));
    fprintf("  x1          x2           Maximum_func       objective_func \n");
    
    %Storing the different fitness values
    fitness_val = zeros(N);
    
    for i = 1:N
        fitness_val(i) = maximumfunc(variable(i,1),variable(i,2));
        
        % Variable 'o' stores the original function value which is to be
        % minimised
        o = objective_func(variable(i,1),variable(i,2));
          
        fprintf("%.3f           %.3f            %.3f        %.3f\n\n",variable(i,1),variable(i,2),fitness_val(i),o);
    end
      