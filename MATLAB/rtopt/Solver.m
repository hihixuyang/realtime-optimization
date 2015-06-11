classdef(Abstract) Solver < handle & TestEnv
    %SOLVER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        dyn_;
        timepoint; % 
        M0;
        N0;
        %M0_vec;
        %N0_vec;
        M0_size;
        N0_size;
       
        h;
        JDot;
    end
    
    properties(Dependent)
        vec;
        dyn;
        
        JDot_u;
        JDot_x;
    end
    
    
    methods(Abstract)
        integrate(obj, func, tspan, y0);
    end
    
    methods
        
        function set.dyn(obj, dyn)
            obj.dyn_ = dyn;
            obj.h =  obj.dyn.environment.mesh(1); 
        end
        
        function res =  get.dyn(obj)
            res = obj.dyn_;
        end
        
        function res = get.vec(obj)
            res = obj.dyn.backdoor_vec;
        end
        
        function set.vec(obj, vec)
            obj.dyn.backdoor_vec = vec;
        end
        
         function res = get.M0(obj)
             if isempty(obj.M0)
                 n_state = obj.dyn.robot.n_state;
                 obj.M0 = eye(n_state);
             end
             res = obj.M0;
         end
        
        function res = get.N0(obj)
            if isempty(obj.N0)
                [n_state, n_contr, n_var] = obj.getParams();
                obj.N0 = zeros(n_state, n_contr);
            end
            res = obj.N0;
        end
        
        function res = get.M0_size(obj)
            
            if isempty(obj.M0_size)
                n_state = obj.getParams();
                obj.M0_size = n_state * n_state;
            end
            res = obj.M0_size;
        end
        function res = get.N0_size(obj)
            if isempty(obj.N0_size)
                [n_state, n_contr] = obj.getParams();
                obj.N0_size = n_state * n_contr;
            end
            res = obj.N0_size;
        end
        
        function res = get.JDot(obj)
            obj.JDot = obj.dyn.dotD(obj.timepoint);
            res = obj.JDot;
        end
        function res = get.JDot_x(obj)
            n_state = obj.dyn.robot.n_state;
            res = obj.JDot(:, 1:n_state);
        end
        function res = get.JDot_u(obj)
            n_state = obj.dyn.robot.n_state;
            res = obj.JDot(:, n_state + 1:end);
        end
        
    end
    
    methods %Help Functions
        function [n_state, n_contr, n_var, n_timepoints] = getParams(obj)
            n_state = obj.dyn.robot.n_state;
            n_contr = obj.dyn.robot.n_contr;
            n_var = obj.dyn.robot.n_var;
            n_timepoints = obj.dyn.environment.n_timepoints;
        end
        function [F, M, N, J] = helperCreateMatrizen(obj, Y)
            
            [n_state, n_contr, n_var] = obj.getParams();
            
            F = Y(1:n_state, 1);
            M = sparse(reshape(Y(n_state + 1: n_state + obj.M0_size, 1), [n_state, n_state]));
            N = sparse(reshape(Y(n_state + obj.M0_size + 1: n_state + obj.M0_size + obj.N0_size, 1), [n_state, n_contr]));
            J = [M, N];
        end
        function y0 = helperCreateInitialConditions(obj, varargin)
            [n_state, n_contr, n_var] = obj.getParams();
            
            if (nargin == 2)
                obj.nextStep(varargin{1})
            end
                        
            y0 = obj.helperCreateVektor(obj.dyn.state(:, obj.timepoint), obj.M0, obj.N0);
        end
        function y = helperCreateVektor(obj, F, M, N)
            [n_state, n_contr, n_var] = obj.getParams();
            
            y = zeros(n_state + obj.M0_size + obj.N0_size, 1);
            y(1:n_state, 1) = F;
            y(n_state + 1: n_state + obj.M0_size, 1) = reshape(M, [obj.M0_size, 1]);
            y(n_state + obj.M0_size + 1: n_state + obj.M0_size + obj.N0_size, 1) = reshape(N, [obj.N0_size, 1]);
        end
    end
    
    methods
        function s = Solver()
        end
        
        function [F, J, M, N] = ode(obj, timepoint)
            
            obj.nextStep(timepoint);
            mesh = obj.dyn.environment.mesh;
            
            y0 = obj.helperCreateInitialConditions();
            
            tspan = [(timepoint -1)*obj.h, timepoint*obj.h];
            meshGrid = [tspan(1), tspan(1) + mesh(1)/2, tspan(2)]; 
            
            y = obj.integrate(@obj.funcToIntegrate, meshGrid, y0);
            
            [F, M, N, J] = obj.helperCreateMatrizen(y);
            
            %J = [M, N];
        end
        
        function dy = funcToIntegrate(obj, t, y)
            
        end
        
        function nextStep(obj, timepoint)
            obj.timepoint = timepoint;
        end
            

    end
    
    methods
        function setupTest(obj,n_intervals)
            % Quadrocopter soll 5 Meter hoch fliegen
            xbc = [         ... Variablenname L�nge   Name
                ... Anfangsbedingung
                0, 0, 0,    ...     r           3      Ortsvektor
                1, 0, 0, 0, ...     q           4      Quaternion (Einheitsquaternion)
                0, 0, 0,    ...     v           3      Translatorische Geschwindigkeit
                0, 0, 0;    ...     w           3      Winkelgeschwindigkeit
                ... Endbedingung
                0, 0, 5,    ...
                1, 0, 0, 0, ...
                0, 0, 0,    ...
                0, 0, 0     ...
                ];
            
            
            env = Environment();
            env.xbc = xbc;
            env.setUniformMesh(uint8(n_intervals));
                       
            model = Quadrocopter();
            
            obj.dyn = BasisQDyn(model, env, obj);
            obj.dyn.vec = rand(17* (n_intervals+1), 1);
            
        end
    end
    
    methods(Test)
    end
end

