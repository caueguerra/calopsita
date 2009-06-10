<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<script type="text/javascript">
$(document).ready(function() {
    var daysBetweenTodayAndStartDate = (parseInt('${today.dayOfYear}') + 365 * parseInt('${today.year}')) - (parseInt('${iteration.startDate.dayOfYear}') + 365 * parseInt('${iteration.startDate.year}'));
    var daysBetweenEndDateAndToday = (parseInt('${iteration.endDate.dayOfYear}') + 365 * parseInt('${iteration.endDate.year}')) - (parseInt('${today.dayOfYear}') + 365 * parseInt('${today.year}'));
    var daysBetweenEndDateAndStartDate = (parseInt('${iteration.endDate.dayOfYear}') + 365 * parseInt('${iteration.endDate.year}')) - (parseInt('${iteration.startDate.dayOfYear}') + 365 * parseInt('${iteration.startDate.year}'));

    if (daysBetweenTodayAndStartDate > 0 && (isNaN(daysBetweenEndDateAndToday) || daysBetweenEndDateAndToday > 0)) {
        $('#start_date').css( {
            'float': 'left'
        });
        $('#start_today_line').css( {
            'float': 'left'
        });
        $('#end_date').css( {
            'float': 'left'
        });
        if (isNaN(daysBetweenEndDateAndToday)) {
            $('#start_today_line').css( {
                'width' : 300
            });
            $('#start_end_line').css( {
                'width' : 300
            });
            $('#end_date').html('?');
            $('#end_date').css( {
                'font-size' : 40
            });
            $('#end_date').css( {
                'height': 55
            });
        } else {
          $('#start_today_line').css( {
              'width' : 600 * ((daysBetweenTodayAndStartDate - 1) / daysBetweenEndDateAndStartDate)
          });
          $('#start_end_line').css( {
              'width' : 600 * ((daysBetweenEndDateAndToday - 1) / daysBetweenEndDateAndStartDate)
          });
        }
        $('#start_end_line').css( {
            'float' : 'left'
        });
    }
    if ((isNaN(daysBetweenTodayAndStartDate) || daysBetweenTodayAndStartDate < 0) && (isNaN(daysBetweenEndDateAndToday) || daysBetweenEndDateAndToday > 0)) {
        $('#start_date').css( {
            'float': 'right'
        });
        $('#end_date').css( {
            'float': 'right'
        });
        $('#start_today_line').css( {
            'float': 'right'
        });
        if (isNaN(daysBetweenEndDateAndToday) || isNaN(daysBetweenTodayAndStartDate)) {
            $('#start_today_line').css( {
                'width' : 300
            });
            $('#start_end_line').css( {
                'width' : 300
            });

            if (isNaN(daysBetweenEndDateAndToday)) {
              $('#end_date').html('?');
              $('#end_date').css( {
                  'font-size' : 40
              });
              $('#end_date').css( {
                  'height': 55
              });
            } 
            if (isNaN(daysBetweenTodayAndStartDate)){
                $('#start_date').html('?');
                $('#start_date').css( {
                    'font-size' : 40
                });
                $('#start_date').css( {
                    'height': 55
                });
            }
        } else {
          $('#start_today_line').css( {
              'width' : -600 * ((daysBetweenTodayAndStartDate + 1) / daysBetweenEndDateAndToday)
          });
          $('#start_end_line').css( {
              'width' : 600 * ((daysBetweenEndDateAndToday - 1) / daysBetweenEndDateAndToday)
          });
        }
        $('#start_today_line').css( {
            'border-width' : 0
        });
        $('#start_end_line').css( {
            'float' : 'left'
        });
    }
    if (daysBetweenEndDateAndToday < 0) {
        $('#start_date').css( {
            'float': 'left'
        });
        $('#start_today_line').css( {
            'display': 'none'
        });
        $('#today_start').css( {
            'display': 'none'
        });
        $('#end_date').css( {
            'float': 'left'
        });
        $('#today_end').show();
        $('#today_end_line').show();
        $('#start_end_line').css( {
            'width' : 600 * ((daysBetweenEndDateAndStartDate - 1) / daysBetweenTodayAndStartDate)
        });
        $('#start_end_line').css( {
            'float' : 'left'
        });
        $('#today_end_line').css( {
            'width' : -600 * ((daysBetweenEndDateAndToday + 1) / daysBetweenTodayAndStartDate)
        });
    }
});
</script>

	<div id="projects">
	    <p><fmt:message key="project.name"/>: ${project.name}</p>
	</div>
	
  <c:if test="${not empty iteration}">
	<div id="timeline">
        <div id="start_and_today">
    		<div id="start_date" class="date" >
    			<div class="year">${iteration.startDate.year }</div>
    			<div class="day">${iteration.startDate.dayOfMonth }</div>
    			<div class="month"><joda:format value="${iteration.startDate}" pattern="MMM" /></div>
    		</div>
    		
    		<hr class="line" id="start_today_line" />
    		
    		<div id="today_start" class="date today" >
    			<div class="year">${today.year }</div>
    			<div class="day">${today.dayOfMonth }</div>
    			<div class="month"><joda:format value="${today}" pattern="MMM" /></div>
    		</div>
		</div>
    
		<hr class="line" id="start_end_line" />
    
		<div id="today_and_end">
            <div id="today_end" class="date today" >
              <div class="year">${today.year }</div>
              <div class="day">${today.dayOfMonth }</div>
              <div class="month"><joda:format value="${today}" pattern="MMM" /></div>
            </div>
        
            <hr class="line" id="today_end_line" />
            
    		<div id="end_date" class="date" >
    			<div class="year">${iteration.endDate.year }</div>
    			<div class="day">${iteration.endDate.dayOfMonth }</div>
    			<div class="month"><joda:format value="${iteration.endDate}" pattern="MMM" /></div>
    		</div>
        </div>
	</div>
  
    <div id="iteration_text">
      <p><fmt:message key="iteration.goal"/>: ${iteration.goal}</p>
      <c:if test="${not empty iteration.startDate}">
  	    <p><fmt:message key="iteration.startDate"/>: ${iteration.formattedStartDate}</p>
      </c:if>
      <c:if test="${not empty iteration.endDate}">
  	    <p><fmt:message key="iteration.endDate"/>: ${iteration.formattedEndDate}</p>
      </c:if>
  </div>
  <a href="javascript:toggle('iteration');"><fmt:message key="edit"/></a><br/>
  <%@include file="editForm.jsp" %>
  
  <div id="help" class="dialog" title="Adding and Removing Cards">
  	<fmt:message key="iteration.help.addingAndRemovingCards"/>
  </div>
  <div id="todo_cards" class="selectable cards">
  	<h2><fmt:message key="toDo"/> <a href="#" onclick="return show_help()">?</a></h2>
  	<ol id="todo_list" class="board">
  		<c:forEach items="${iteration.todoCards}" var="card" varStatus="s">
  			<c:set var="cardId">cards</c:set>
  			<%@include file="storyCard.jsp" %>
  		</c:forEach>
  	</ol>
  </div>
  <div id="done_cards" class="selectable cards">
  	<h2><fmt:message key="done"/> <a href="#" onclick="return show_help()">?</a></h2>
  	<ol id="done_list" class="board">
  		<c:forEach items="${iteration.doneCards}" var="card" varStatus="s">
  			<c:set var="cardId">done</c:set>
  			<%@include file="storyCard.jsp" %>
  		</c:forEach>
  	</ol>
  </div>
  <div id="backlog" class="selectable clear">
  	<h2><fmt:message key="backlog"/></h2>
  
  	<ol id="backlog_list" class="board">
  		<c:forEach items="${otherCards}" var="card" varStatus="s">
  			<c:set var="cardId">backlog</c:set>
  			<%@include file="storyCard.jsp" %>
  		</c:forEach>
  	</ol>
  </div>
</c:if>
<c:if test="${empty iteration}">
<p>There is no current iteration</p>
</c:if>
