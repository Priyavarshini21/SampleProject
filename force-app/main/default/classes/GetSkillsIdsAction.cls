global with sharing class GetSkillsIdsAction {
@InvocableMethod(label='Get Skills Ids' description='Return Ids of Skills') 
global static List<List<Id>> getSkillsIds() {
List<Id> skillsIds = new List<Id> ();

/*
* 18 char Skills Ids in the org:
*
* French - 0C55g000000bn8ICAQ
* Spanish - 0C55g000000bn8DCAQ
*/

skillsIds.add('0C5RM000000028I0AQ');
skillsIds.add('0C5RM000000026R0AQ');

return new List<List<Id>> {skillsIds};
}
}