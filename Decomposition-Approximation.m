%create a random theta1 array
        a = 0;
        b = 170;
        theta1 = (b-a).*rand(25000,1) + a;
        
%create a random theta2 array
        aa = -90;
        bb = 90;
        theta2 = (bb-aa).*rand(25000,1) + aa;
  
        
        %work_space = cell(40);
        work_space_xy = cell(40);
        theta_array = cell(40);
        for c = 1:25000
            thetaone = theta1(c);
            thetatwo = theta2(c);
            
            outputX = fkx(thetaone, thetatwo);
            outputY = fky(thetaone, thetatwo);
            
            x = ((ceil((outputX/10)+20)));
            y = ((ceil((outputY/10)+20)));
            
            if isempty(work_space_xy{x,y})
                   work_space_xy{x,y} = [outputX, outputY];
                   theta_array{x,y} = [thetaone, thetatwo];
            else
                    work_space_xy{x,y} = [work_space_xy{x,y}; outputX,outputY];
                    theta_array{x,y} = [theta_array{x,y}; thetaone, thetatwo];
            end
            
        end
       
        
        cof = cell(40);
        %kmeans
        for i = 1:40
            for j = 1:40
                %disp(size(theta_space_xy{i,j},1));
                if size(work_space_xy{i,j},1) > 5
                    clusters = kmeans(work_space_xy{i,j},2);
                    cluster1_XY = [];
                    cluster1_theta1 = [];
                    thetaone = [];
                    
                    cluster2_XY = [];
                    cluster2_theta1 = [];
                    cluster2_theta2 = [];
                    
                    for t = 1:size(work_space_xy{i,j},1)
                        if clusters(t) == 1
                            cluster1_XY = [cluster1_XY; work_space_xy{i,j}(t,:)];
                            cluster1_theta1 = [cluster1_theta1; theta_array{i,j}(t)];
                            thetaone = [thetaone; theta_array{i,j}(t+1)];
                            
                        else 
                            cluster2_XY = [cluster2_XY; work_space_xy{i,j}(t,:)];
                            cluster2_theta1 = [cluster2_theta1; theta_array{i,j}(t)];
                            cluster2_theta2 = [cluster2_theta2; theta_array{i,j}(t+1)];
                            
                        end
                        
                    end
                    
                    
                    kone = fitlm(cluster1_XY, cluster1_theta1);
                    c = kone.Coefficients(1,1).Variables;
                    b = kone.Coefficients(2,1).Variables;
                    a = kone.Coefficients(3,1).Variables;
                    
                    
                    kone1 = fitlm(cluster1_XY, thetaone);
                    c1 = kone1.Coefficients(1,1).Variables;
                    b1 = kone1.Coefficients(2,1).Variables;
                    a1 = kone1.Coefficients(3,1).Variables;
                    
                    ktwo = fitlm(cluster2_XY, cluster2_theta1);
                    d = ktwo.Coefficients(1,1).Variables;
                    e = ktwo.Coefficients(2,1).Variables;
                    f = ktwo.Coefficients(3,1).Variables;
                    
                    ktwo1 = fitlm(cluster2_XY, cluster2_theta2);
                    c2 = ktwo1.Coefficients(1,1).Variables;
                    b2 = ktwo1.Coefficients(2,1).Variables;
                    a2 = ktwo1.Coefficients(3,1).Variables;
                    
                    cof_matrix1 = [a b c, a1 b1 c1];
                    cof_matrix2 = [d e f, a2 b2 c2];
                    
                    cof{i,j} = [cof_matrix1;cof_matrix2];
                  
                end    
            end
        end
        prediction_theta1 = [];
        prediction_theta2 = [];
        
        calc_theta1 = [];
        calc_theta2 = [];
        for i=1:100
            %create a random theta1 
            a = 0;
            b = 170;
            theta1 = (b-a).*rand(1) + a;
        
            %create a random theta2 
            aa = -90;
            bb = 90;
            theta2 = (bb-aa).*rand(1) + aa;
            
            x = fkx(theta1, theta2);
            y = fky(theta1, theta2);
            
            x_ind = ((ceil((x/10)+20)));
            y_ind = ((ceil((y/10)+20)));
            
            %get the coefficeints from   cof{x_ind,y_ind}(1) = cof a b c
            
            if size(cof{x_ind, y_ind}) > 1
                theta1_calculated = (cof{x_ind, y_ind}(1)*x) + (cof{x_ind, y_ind}(2)*y) + cof{x_ind, y_ind}(3);
                theta2_calculated = (cof{x_ind, y_ind}(4)*x) + (cof{x_ind, y_ind}(5)*y) + cof{x_ind, y_ind}(6);
                
                
                k1 = (abs(((theta1_calculated)/(theta1))-(theta1))) *100;
                k2 = (abs(((theta2_calculated)/(theta2))-(theta2))) *100;
                
      
            end
            
        end
       
        scatter(k1, k2, 'r');
        
        function [x] = fkx(one,two)
            x = 100*(cosd(one))+(100*(cosd(one+two)));
        end
        
        function [y] = fky(one,two)
            y = 100*(sind(one))+(100*(sind(one+two)));
        end
        
 