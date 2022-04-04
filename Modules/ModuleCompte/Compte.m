classdef Compte < handle
%
% Classe Compte
% 
% PROPRITÉTÉS : 
%
%
%
    % Initialisation des propriétés privée.
    properties (Access = private)
    identifiant = char.empty();
    client = Client.empty();
    soldeCheque = 0;
    soldeEpargne = 0;
    end

    methods (Access = public)
        function nouveauCompte = Compte(depotCheque,depotEpargne)
        %
        % Cette fonction est le constructeur de la classe compte
        % elle modifie les valeurs initales dans la base de données.
        %
        % PARAMÈTRES :
        % - depotCheque : un double qui correspond au dépôt initial dans le
        %   compte chèque.
        % - depotEpargne : un double qui correspond au dépôt initial dans
        %   le compte épargne.
        %
        % VALEUR DE RETOUR : 
        % - nouveauCompte
        %
            % Vérification que les valeurs entrées sont valide.
            if nargin ~=0
                validateattributes(depotCheque,{'double'},{'positive'});
                validateattributes(depotCheque,{'double'},{'positive'});
                nouveauCompte.soldeCheque = depotCheque;
                nouveauCompte.soldeEpargne = depotEpargne;
            end
        end

        function valeurLue = getIdentifiant(compte)
        %
        % Cette fonction est l'accesseur pour l'identifiant du compte.
        %
        % PARAMÈTRES :
        % - compte : référence vers le type compte.
        %
        % VALEUR DE RETOUR : 
        % - valeurLue : chaine de caractères représentant l'identifiant du
        % compte.
        %    
            valeurLue = compte.identifiant;
        end

        function valeurLue = getProprietaire(compte)
        %
        % Cette fonction est l'accesseur pour le propriétaire du compte.
        %
        % PARAMÈTRES :
        % - compte : référence vers le type compte.
        %
        % VALEUR DE RETOUR : 
        % - valeurLue : chaine de caractères représentant le propriétaire du
        % compte.
        %    
            valeurLue = compte.client;
        end
        
        function valeurLue = getSoldeCheque(compte)
        %
        % Cette fonction est l'accesseur pour le solde du compte de chèques.
        %
        % PARAMÈTRES :
        % - compte : un double représentant le solde du compte chèques
        %
        % VALEUR DE RETOUR : 
        % - valeurLue : un double représentant le solde du compte chèque.
        % 
            valeurLue = compte.soldeCheque;
        end 
        function valeurLue = getSoldeEpargne(compte)
        %
        % Cette fonction est l'accesseur pour le solde du compte épargne.
        %
        % PARAMÈTRES :
        % - compte : un double représentant le solde du compte épargne
        %
        % VALEUR DE RETOUR : 
        % - valeurLue : un double représentant le solde du compte épargne.
        % 
            valeurLue = compte.soldeEpargne;
        end
        % fait les sets tantot
        %****************************************************
        function setClient(ref,client)
            ref.client = client;
        end
        function setIdentifiant(ref,nouvIdentfifiant)
            ref.identifiant = nouvIdentfifiant;
        %****************************************************
        end
        function valeurResultat = eq(ref,compteComp)
        %
        % Cette fonction compare les informations de 2 comptes ensemble.
        %
        % PARAMÈTRES :
        % - ref : une référence vers l'objet.
        % - compteComp : un compte à comparer à l'objet.
        %
        % VALEUR DE RETOUR : 
        % - valeurRésultat : un booléen qui indique si les comptes sont égaux ou non.
            
            valeurResultat = 0;
            if isa(compteComp,'Compte')
                if strcmp(compteComp.getIdentifiant(),ref.identifiant) 
                    if compteComp.getProprietaire() == ref.client 
                        if compteComp.getSoldeCheque() == ref.soldeCheque
                            if compteComp.getSoldeEpargne() == ref.soldeEpargne
                                valeurResultat =1;
                            end
                        end
                    end
                end
            end
        end

        function DepotCheques(ref, montant)
        %
        % Cette fonction permet de faire un dépot dans le compte de chèques.
        %
        % PARAMÈTRES :
        % - ref : une référence vers l'objet.
        % - montant : un double correspondant au montant à ajouter au solde
        % du compte chèque.
        % 
            validateattributes(montant,{'double'},{'nonnegative','scalar'});
            ref.soldeCheque = ref.soldeCheque + montant;
        end    

        function DepotEpargne(ref, montant)
        %
        % Cette fonction permet de faire un dépot dans le compte de épargne.
        %
        % PARAMÈTRES :
        % - ref : une référence vers l'objet.
        % - montant : un double correspondant au montant à ajouter au solde
        % du compte épargne.
        % 
            validateattributes(montant,{'double'},{'nonnegative','scalar'});
            ref.soldeEpargne = ref.soldeEpargne + montant;
        end
        function RetraitCheques(ref,montant)
        %
        % Cette fonction permet de faire un retrait dans le compte de chèques.
        %
        % PARAMÈTRES :
        % - ref : une référence vers l'objet.
        % - montant : un double correspondant au montant à retirer au solde
        % du compte épargne.
        %
            validateattributes(montant,{'double'},{'nonnegative','scalar'});
            ref.soldeCheque = ref.soldeCheque - montant;
        end    

        function RetraitEpargne(ref, montant)
        %
        % Cette fonction permet de faire un retrait dans le compte de épargne.
        %
        % PARAMÈTRES :
        % - ref : une référence vers l'objet.
        % - montant : un double correspondant au montant à retirer au solde
        % du compte épargne.
        %
            validateattributes(montant,{'double'},{'nonnegative','scalar'});
            ref.soldeEpargne = ref.soldeEpargne - montant;
        end

    end

end