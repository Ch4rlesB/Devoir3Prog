classdef Compte < handle
%
% 
%
    properties (Access = private)
    identifant = char.empty();
    client = Client();
    soldeCheque = 0;
    soldeEpargne = 0;
    end

    methods (Access = public)
        function compte = Compte(identifiant,client)
            assert(nargin ~=0);
            validateattributes(identifiant,{'char'},{'nonnegative'});

            compte.client = client;
            compte.identifant = identifiant;
        end
        function [valeurLue] = getIdentifiant(compte)
            valeurLue = compte.identifant;
        end

        function [valeurLue] = getProprietaire(compte)
            valeurLue = compte.client;
        end
        
        function [valeurLue] = getSoldeCheque(compte)
            valeurLue = compte.soldeCheque;
        end
        function [valeurLue] = getSoldeEpargne(compte)
            valeurLue = compte.soldeEpargne;
        end

        function valeurResultat = eq(ref,compteComp)
            valeurResultat = 0;
            if isequal(compteComp,Compte)
                if compteComp.getIdentifiant() == ref.identifiant 
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

        function DepotCheques(ref,montant)
            validateattributes(montant,{'double'},{'nonnegative','scalar'});
            ref.soldeCheques = ref.soldeCheques + montant;
        end    

        function depotEpargne(ref, montant)
            validateattributes(montant,{'double'},{'nonnegative','scalar'});
            ref.soldeEpargne = ref.soldeEpargne + montant;
        end
        function RetraitCheques(ref,montant)
            validateattributes(montant,{'double'},{'nonnegative','scalar'});
            ref.soldeCheques = ref.soldeCheques - montant;
        end    

        function RetraitEpargne(ref, montant)
            validateattributes(montant,{'double'},{'nonnegative','scalar'});
            ref.soldeEpargne = ref.soldeEpargne - montant;
        end

    end

end