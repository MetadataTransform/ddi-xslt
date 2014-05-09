$(document).ready(function(){
	$('.questionName').click(function(e){
		var qid = $(this).parent().attr("id");
		qid = qid.replace('question-','');
		$(this).unbind('click');
		//console.log(qid);
		$.ajax({
			url: backend+'qb-get-study-units.xql?callback=?',
			dataType: 'jsonp',
			data: {
				qid:qid,
			},
			success: loadedQuestionInfo
		});
		
	});
});

function loadedQuestionInfo(data){
	var output = '<table class="question-in-studies-list">';
	if('study' in data){	
		if(data['study'].length > 1){
			var series_id = 0;
			$.each(data['study'], function(i,study){
				if(study['series']['series_id'] != series_id){
					output +='<tr><td colspan="2"><strong>'+study['series']['name']['en']+'</strong></td></tr>';
					series_id = study['series']['series_id'];
				}
				output += renderStudyLink(study);
			});
		}else{
			output += renderStudyLink(data.study);
		}
		output += '</table>';
		$("#question-"+data['question-id']).after(output);
		
	}else{
		$("#question-expand-"+data['question-id']).after('no studies found');
	}
	
	function renderStudyLink(study){
		var output = '<tr><td class="study-in-list">'+study['questionItemName']['en']+'</td> <td><a href="http://bull.ssd.gu.se:8080/exist/rest//db/ddi3/xslt/study.xql?id='+study['studyId']+'#question-'+data['question-id']+'">'+study['title']['sv']+'</a></td></tr>';
		return output;
	}
}