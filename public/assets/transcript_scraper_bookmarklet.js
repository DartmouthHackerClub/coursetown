(function(){var e,t,n,r,i,s,o,u,a,f,l,c;window.location.href==="https://banner.dartmouth.edu/banner/groucho/bwskotrn.P_ViewTran"?(e="http://coursetown.hacktown.cs.dartmouth.edu/",c=""+e+"reviews/from_transcript",i=""+e+"am_i_logged_in",n=""+e+"auth/cas?callback=/reviews/from_transcript",u=function(e){var t;return t=!1,e("table.datadisplaytable tr").each(function(n,r){var i,s;i=r.children,!t&&i.length===1&&e(i[0]).find('a[name="insti_credit"]').length>=1&&(t=!0);if(!t||i.length<7)return;s=!0,e(i).each(function(t,n){return s=s&&(e(n).attr("class")==="dddefault"||e(n).attr("class")==="dddead")});if(!s)return;return e(i[6]).html('<span class="redacted-data" style="color:#2ad;">[removed]</span>')})},l=function(){var e;return e=document.documentElement.innerHTML.replace(/"/g,"&quot;").replace(/'/g,"&apos;"),$("<form action='"+c+"' method='POST'>      <input type='hidden' name='transcript' value='"+e+"'>      </form>").submit()},a=function(){return $("table.datadisplaytable tr").each(function(e,t){var n;n=t.children;if(n.length!==2)return;if($(n[0]).attr("class")==="ddlabel"&&($(n[0]).html()==="Name :"||$(n[0]).html()==="Birth Date:"))return $(n[1]).html('<span class="redacted-data" style="color:#2ad;">[removed]</span>')})},s=function(){return alert("Looks like you aren't logged in on Course Picker. Please log in and then try again")},t=function(){return $.ajax({dataType:"json",type:"GET",url:i,success:function(e){return e==="yes"?(a(),o()):s()},error:function(e){return s()}})},r=function(){return a(),o()},o=function(){var e;return e="It's helpful to have reviewers report their grades to give their reviews context. All of Course Picker's data is anonymized, so if you report your grades nobody (neither us NOR anyone malicious) will be able to trace them to your identity.\n\nPress OK to report your grades along with the courses you took (to save you one more step in the review process). \n\nPress CANCEL to have your grades removed from this transcript first (just like we've already removed your name).",confirm(e)||u(jQuery),l()},typeof jQuery=="undefined"?(f=document.createElement("script"),f.src="https://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js",f.onload=r,document.body.appendChild(f)):r):(alert("It looks like you're using this in the wrong place.\n\n1. Make sure you're logged in on Hacker Club's Course Picker\n2. Make sure you've dragged the bookmarklet into your bookmarks bar\n3. Navigate to: Banner > Academic Transcript\n4. Pick:\n	Transcript Level: Undergraduate.\n	Transcript Type: Undergraduate Unofficial.\n5. Hit 'Submit'. You should now see your transcript.\n6. Click the bookmarklet again."),"\nWe'll send you to bannerstudent now",window.location.href="https://dartmouth.edu/bannerstudent")}).call(this);