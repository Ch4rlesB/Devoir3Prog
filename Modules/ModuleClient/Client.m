%
% La classe Client représente le profil d'un client d'une banque.
%
%   Attribut :
% -	prenom: Une chaîne de caractères qui représente le prénom.
% -	nom: Une chaîne de caractères qui représente le nom.
% - nas: Une chaîne de caractères qui représente le numéro 
%   d'assurances sociale.
% - nbCompte: Un double qui correspond au nombre de comptes de banques que 
%   client qui possède. La valeur par défaut est zéro.
% - compteTab: Un tableau de type Compte qui doit être initialisé 
%   avec le bon type, mais vide.Il s-agit des références vers les comptes
%   des clients du client.
% 
classdef Client < handle 
    properties (Access=private)
       prenom = char.empty();
       nom = char.empty();
       nas = char.empty();
       nbCompte = 0;
       compteTab = Compte.empty();        
    end

    methods (Access = public)        
        %
        % La méthode Client est le constructeur de la classe Client.
        %
        % PARAMÈTRES :
        % -	nouvPrenom: Une chaîne de caractères qui correspond au 
        %   prénom du client.
        % -	nouvNom: Une chaîne de caractères qui correspond au 
        %   nom du client.
        % -	nouvNas: Une chaîne de caractères qui correspond au 
        %   numéro d'assurance sociale du client.
        %
        % VALEUR DE RETOUR : 
        % - nouveauClient: Une référence vers l objet.
        %
        function nouveauClient = Client (nouvPrenom,nouvNom,nouvNas)
            % Vérification du nombre d'entrée pour s'assurer qu'au moins
            % une entrée soit donné.
            if nargin~=0
                % Valider que le prénom est de type char et qu il 
                % s'agit d'un scalaire de texte.
                validateattributes(nouvPrenom,{'char'},{'row'});
                % Valider que le nom est de type char et qu'il s'agit d'un 
                % scalaire de texte.
                validateattributes(nouvNom,{'char'},{'row'});
                % Valider que le numéro d’assurance est de type char et 
                % qu'il s'agit d’un scalaire de texte de dimensions 1×9.
                validateattributes(nouvNas,{'char'},{'row','size' , [1,9]});
                % Mettre les attributs de l’objet à jour. 
                nouveauClient.prenom = nouvPrenom;  
                nouveauClient.nom = nouvNom;             
                nouveauClient.nas=nouvNas;   
            end
        end
        %
        % Accesseur pour l’attribut qui contient le prénom du client.
        %
        function [valeurLue] = getPrenom (objet)
            valeurLue = objet.prenom;
        end
        %
        % Accesseur pour l'attribut qui contient le nom du client.
        %
        function [valeurLue] = getNom (objet)
            valeurLue = objet.nom;
        end
        %
        % Accesseur pour l'attribut qui contient le numéros d'assurence 
        % sociale du client.
        %
        function [valeurLue] = getNumeroAssuranceSociale (objet)
            valeurLue = objet.nas;
        end
        %
        % Accesseur pour l'attribut qui contient le numéros d'assurence 
        % sociale du client.
        %
        function [valeurLue] = getNbComptes (objet)
            valeurLue = objet.nbCompte;
        end
        %
        % Méthode qui accède à un compte spécifique pigé dans le tableau 
        % de comptes 
        %
        % PARAMÈTRES :
        % - ref: Une référence vers l'objet.
        % -	indiceCompte: Un double qui correspond à l'indice du compte.
        %
        % VALEUR DE RETOUR : 
        % - refCompte: Une référence vers le compte.
        %
        function [refCompte] = ObtenirCompte(ref,indiceCompte)
            %
            validateattributes(indiceCompte,'double',{'scalar','integer','positive'});
            %
            assert(indiceCompte<=ref.nbCompte);
            %
            refCompte = ref.compteTab(indiceCompte);
        end
        %
        % Méthode qui ajoute un nouveau compte à la liste de comptes.  
        %
        % PARAMÈTRES :
        % - ref: Une référence vers l'objet.
        % -	nouveauCompte: Un Compte qui correspond à un nouveau compte 
        %   à ajouter à la liste de comptes.
        %
        % VALEUR DE RETOUR : 
        % - rien.
        %
        function AjouterCompte(ref, nouveauCompte)
            % Valider que le compte est une instance de la classe Compte 
            % et qu il s’agit d’un scalaire.
            validateattributes(nouveauCompte,{'Compte'},{'scalar'});
            % Vérification du compte si il est déja présent dans la liste.
            for i=1:size(ref.compteTab,2)
                assert(nouveauCompte~=ref.compteTab(i),'Ce compte est deja relier a ce profil client.');
            end
            % Ajout du nouveau compte a la liste de tableau.
            ref.compteTab = [ref.compteTab;nouveauCompte];
            % Incrementation du nombre de compte puisque nous venons d'en
            % ajouter un.
            ref.nbCompte = ref.nbCompte + 1;                     
        end
        %
        % Surcharge de l’opérateur d’égalité (==). 
        %
        % PARAMÈTRES :
        % - ref: Une référence vers l'objet.
        % -	client: Un Client avec lequel comparer l'objet.
        %
        % VALEUR DE RETOUR : 
        % - egal: Un booléen qui indique si les deux instances sont 
        %   egales ou non.
        %
        function egal = eq(ref,client)
            % Verification du client en entree si il fait partie de
            % l'instance de Client.
            if ~isequal(client,Client)
                egal = 0;
            else
                % Passage pour la verification a travers du tableau de
                % compte
                for i=1:size(ref.compteTab,2)
                    % Verification du client si il possede tous les
                    % attributs.
                    if (Compte.eq(ref,client)==1)
                        egal = 1;
                    end
                end
            end
        end
    end 
end