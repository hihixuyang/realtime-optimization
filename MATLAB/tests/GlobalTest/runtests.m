%RUN_TEST Diese Datei starten die Tests f�r template.
%   Matlab besitzt sogenanntes unit test framework. Dies ist ein kleines
%   Beispiel dazu
%   Mehr Informationen gibt es unter: http://de.mathworks.com/help/matlab/matlab_prog/create-simple-test-suites.html
import matlab.unittest.TestSuite

global TEST;
TEST = true;


%Create Suite from SolverTest Class
%The fromClass method creates a suite from all Test methods in the SolverTest class.

% suiteBasisQDyn = TestSuite.fromClass(?BasisQDyn);
% resultDyn = run(suiteBasisQDyn);                          %Check

%suiteConstraints = TestSuite.fromClass(?Constraints);
%resultConstraints = run(suiteConstraints);                %Check

<<<<<<< HEAD
%suiteMultiShooting =MultiShooting();
%resultMultiShooting = run(suiteMultiShooting);                %Check
=======
% suiteMultiShooting = TestSuite.fromClass(?MultiShooting);
% resultMultiShooting = run(suiteMultiShooting);                %Check
>>>>>>> baf2f11e89ea1743450eb56aef48cb2029dad76e
        
% suiteForwEuler = TestSuite.fromClass(?ForwEuler);
% resultForwEuler = run(suiteForwEuler);                    %NOT 

<<<<<<< HEAD
suiteODE15iM2 = ode15iM2(); 
resultODE15iM2 = run(suiteODE15iM2, 'testOde');                      %Check
=======
% suiteODE15iM2 = TestSuite.fromClass(?ode15iM2);
% resultODE15iM2 = run(suiteODE15iM2);                      %Check
>>>>>>> baf2f11e89ea1743450eb56aef48cb2029dad76e

% suiteCosts = TestSuite.fromClass(?Costs);
% resultCosts = run(suiteCosts);                            %Check
 
% suiteCostsXU = TestSuite.fromClass(?CostsXU);
% resultCostsXU = run(suiteCostsXU);                        %Check

suiteLagrange = TestSuite.fromClass(?Lagrange);
resultLagrange = run(suiteLagrange);

% suiteRiccati = TestSuite.fromClass(?RiccatiManager);
% resultRiccati = run(suiteRiccati);                        %Check

% suiteRTSolver = TestSuite.fromClass(?RealtimeSolver);
% resultRTSolver = run(suiteRTSolver);                        %Check

% 
%Create Suite from SolverTest Class Definition File
%The fromFile method creates a suite using the name of the file to identify the class.

%suiteFile = TestSuite.fromFile('SolverTest.m');
%result = run(suiteFile);