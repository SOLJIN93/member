package shmall.prt;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.print.PageFormat;
import java.awt.print.Printable;
import java.awt.print.PrinterException;
import java.awt.print.PrinterJob;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;


public class A1MemPrint implements Printable {
	
	public String schItem=null, schWord=null;

	public A1MemPrint(String schItem, String schWord) {
		
		this.schItem = schItem;
		this.schWord = schWord;
		//System.out.println("schItem2 :"+schItem);
		//System.out.println("schWord2 :"+schWord);

		// (1) 인쇄 객체 생성
		PrinterJob job = PrinterJob.getPrinterJob();

		// (2) 용지 방향 설정
		// 가로(LANDSCAPE) 설정
		PageFormat pf = job.defaultPage();
		pf.setOrientation(PageFormat.LANDSCAPE); // 세로시 PORTRAIT
		job.setPrintable(this, pf); // 인쇄 작업 설정

		//job.setPrintable(this); // 인쇄 대화상자 사용시 주석 해제

		// (3) 인쇄 대화상자 호출
		if(job.printDialog()==true) {
			try {

		// (4) 인쇄 메소드 호출 
				job.print();
			} catch(PrinterException e) { }
		}
		
	}

	public int print(Graphics gx, PageFormat pf, int curPage) throws PrinterException {

		Access acc = new Access(); // DB 연결과 int totRecord를 구함

		int[] pageLast = null; // 페이지당 마지막 라인 번호

		// (1) 페이지당 마지막 라인 번호 
		if(pageLast==null) {
			int pageLine = 14; // 페이지당 라인수 : 가로=14, 세로=25
			int totPage = (acc.totRecord-1)/pageLine; // 페이지 수
			pageLast = new int[totPage]; // 페이지당 마지막 라인 번호

			for(int i=0; i<totPage; i++) {
				pageLast[i] = (i+1)*pageLine; // i = 페이지 번호 
			}
		}

		// (2) 마지막 페이지 이면 인쇄 종료
		if(curPage>pageLast.length) {
			return NO_SUCH_PAGE;
		}

		// (3) 좌표 이동
		Graphics2D g = (Graphics2D)gx; // Graphics2D 객체 형변환
		g.translate(pf.getImageableX(), pf.getImageableY()); //Match origins to imageable area

		// (4) 페이지당 시작 라인 번호
		int start = (curPage==0)?	0 : pageLast[curPage - 1];
		//System.out.println("start :"+ start);

		// (5) 페이지당 마지막 라인 번호
		int end = (curPage==pageLast.length) ? acc.totRecord : pageLast[curPage];
		System.out.println("end :"+ end);

		// (6) 알림과 항목명 인쇄
		g.drawString("---------------------------------------------------------------------------------------------------------------------------------------------------------", 50, 5);
		g.drawString("번호", 100, 30);
		g.drawString("이름", 200, 30);
		g.drawString("전화", 300, 30);
		g.drawString("생년월일", 400, 30);
		g.drawString("직업", 500, 30);
		g.drawString("---------------------------------------------------------------------------------------------------------------------------------------------------------", 50, 45);

		// (7) 데이터 인쇄
		int recNum = 1 + (curPage*14); // 레코드 번호 : 가로=14, 세로=25
		int y = 0; // y축 좌표
		for(int i=start; i<end; i++) {

			String id = acc.changeDB(i+1);	// 레코드 번호를 아이디로 변환 
			//System.out.println("id :"+ id);
			String sql = null;
			try {

				if(schWord.equals("null") || schWord.equals("")) {
					sql = "SELECT * FROM member WHERE id=? ORDER BY regDate, name ASC";
					acc.psmt = acc.conn.prepareStatement(sql);
					acc.psmt.setString(1, id);
				} else {
					sql = "SELECT * FROM member WHERE id=? and " + schItem + " LIKE ? ORDER BY regDate, name ASC";

					acc.psmt = acc.conn.prepareStatement(sql);
					acc.psmt.setString(1, id);
					acc.psmt.setString(2, "%" + schWord + "%");
				}
				acc.rs = acc.psmt.executeQuery();

				// 검색 레코드가 없을 때
				if(!acc.rs.next()) {
					javax.swing.JOptionPane.showMessageDialog(null, "데이터가 없습니다.");
					acc.rs.close();
					acc.psmt.close();
				}

				String sRecNum = Integer.toString(recNum++);		g.drawString(sRecNum, 100, 65+y*25);
				String name = acc.rs.getString("name");				g.drawString(name, 200, 65+y*25);
				String phone = acc.rs.getString("phone");			g.drawString(phone, 300, 65+y*25);
				String birthday = acc.rs.getString("birthday");		g.drawString(birthday, 400, 65+y*25);
				String job = acc.rs.getString("job");				g.drawString(job, 500, 65+y*25);

				y++;

				acc.rs.close();
				acc.psmt.close();
			} catch(SQLException e) {
				System.err.println("쿼리 오류 1!");
			}
		}

		try {
			acc.conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		g.drawString("---------------------------------------------------------------------------------------------------------------------------------------------------------", 50, 400); // LANDSCAPE
		//g.drawString("--------------------------------------------------------------------------------------------------------", 50, 750); // PORTRAIT
		// (8) 페이지 인쇄
		String sPage = Integer.toString(curPage +1);
		String sPage2 = "-" + sPage + "-";
		//System.out.println("sPage2 :" +sPage2);
		g.drawString(sPage2, 300, 425); // LANDSCAPE
		//g.drawString(sPage2, 250, 775); // PORTRAIT

		return PAGE_EXISTS;
	}


	public class Access {

		private Connection conn;
		private PreparedStatement psmt;
		private ResultSet rs;
		private String sql;

		int totRecord ; // 레코드 개수

		public Access() {
			// (1) DB 설정
			connectDB(); // DB 연결
			recCountDB(); // 총레코드 개수
		}

		public void connectDB() {

			try {
				Class.forName("com.mysql.cj.jdbc.Driver");
			} catch(ClassNotFoundException e) {
				System.out.println("드라이브 없음");
			}
			String url = "jdbc:mysql://localhost:3306/shmall?serverTimezone=UTC&useSSL=false";
			try {
				conn = DriverManager.getConnection(url, "root", "12345678");
			} catch(SQLException e) {
				System.out.println("연결 실패");
			}
		}

		public void recCountDB() { // 레코드 총개수

			try {
				if(schWord.equals("null") || schWord.equals("")) {
					sql = "SELECT COUNT(id) FROM member";
					psmt = conn.prepareStatement(sql);
				} else {
					sql = "SELECT COUNT(id) FROM  member WHERE " + schItem + " LIKE ?";
					psmt = conn.prepareStatement(sql);
					psmt.setString(1, "%" + schWord + "%");
				}

				rs = psmt.executeQuery();
				if(rs.next())	totRecord = rs.getInt(1); // COUNT(pk)한 첫번째 
				//System.out.println("totRecord :"+totRecord);
/*
				int recNum = 1;
				while(rs.next()) {
					totRecord = recNum++;
				}
*/
				// (4) 객체 해제
				rs.close();
				psmt.close();

			} catch(SQLException e) {}
		}

		public String changeDB(int recNum) { // 레코드 번호를 id로 변환

			String id = null;
			try {
				if(schWord.equals("null") || schWord.equals("")) {
					sql = "SELECT * FROM member";
					psmt = conn.prepareStatement(sql);
				} else {
					sql = "SELECT * FROM member WHERE " + schItem + " LIKE ? ORDER BY regDate, name ASC";

					psmt = conn.prepareStatement(sql);
					psmt.setString(1, "%" + schWord + "%");
				}

				rs = psmt.executeQuery();
				int recNum2 = 1; // 레코드 번호
				while(rs.next()) {

					if(recNum2==recNum) {
						id = rs.getString("id");
						//System.out.println("id :"+id);
						break;
					}
					recNum2++;
				}

				rs.close();
				psmt.close();
			} catch(SQLException e) {
				System.err.println("쿼리 오류2!");
			}
			return id;
		}
	}
}
