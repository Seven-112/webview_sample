package com.tur.bumerang.Global.Activity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.SearchView;
import android.widget.TextView;

import androidx.annotation.NonNull;

import com.firebase.client.Firebase;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import com.iamhabib.easy_preference.EasyPreference;
import com.tur.bumerang.Base.BaseActivity;
import com.tur.bumerang.Base.Common;
import com.tur.bumerang.Base.ReqConst;
import com.tur.bumerang.Business.Activity.UserProfileBusinessActivity;
import com.tur.bumerang.Global.Adapter.Chatting_history_listAdapter;
import com.tur.bumerang.Global.Model.ChattingModel;
import com.tur.bumerang.R;

import java.util.ArrayList;

import butterknife.ButterKnife;
import butterknife.OnClick;

public class ChattingHistoryActivity extends BaseActivity {


    Chatting_history_listAdapter chattingHistoryListAdapter;

    ListView review_list;
//    TextView txvbadge;
    SearchView search;
    String userInfo,userId,userName;
    String findCity = null;
    boolean m_bNabBarHS = false;
    String[] myid =null;
    TextView txvbadge;
    LinearLayout LL_imgempty;
    int loginstatus = 0;
    int remeberStatus = 0;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_chatting_history);

        ButterKnife.bind(this);
        userInfo = EasyPreference.with(this).getString("easyMembership", "");
        userId = EasyPreference.with(this).getString("easyUserId", "");
        userName = EasyPreference.with(this).getString("easyUserFirstName", "") + " " + EasyPreference.with(this).getString("easyUserLastName", "");;;
        search = (SearchView) findViewById(R.id.search);

        LL_imgempty = (LinearLayout) findViewById(R.id.LL_imgempty);

        review_list=(ListView)findViewById(R.id.list_chatting_history);
        txvbadge = (TextView)findViewById(R.id.txv_messagebadge);

        loadLayout();

        search.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

            }
        });

//        review_list.setOnItemClickListener(new AdapterView.OnItemClickListener() {
//            public void onItemClick(AdapterView<?> parent, View view,
//                                    int position, long id) {
//
//                // Put in your code here, what you wanted trigger :)
//
//                Intent intent = new Intent(ChattingHistoryActivity.this, ChattingActivity.class);
////                startActivity(intent);
//            }
//        });
        Firebase f = new Firebase(ReqConst.FIREBASE_URL + ReqConst.API_notification + "/user" + (Common.user.getId() == null ? "1" : Common.user.getId()));
        f.removeValue();

        m_bNabBarHS = false;
        if (!(loginstatus == 1 || remeberStatus == 1)){
            m_bNabBarHS = true;

        }
    }

    private  void loadLayout() {
        String compareId = Common.user.getId();
        DatabaseReference mRef = FirebaseDatabase.getInstance().getReference();
        mRef.child("message").addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot dataSnapshot) {
                ArrayList<ChattingModel> ChattingModels = new ArrayList<>();
                for (DataSnapshot snapshot: dataSnapshot.getChildren()) {
                     String allId = snapshot.getKey();
                     String myId = allId.split("_")[0];
                     String otherId = allId.split("_")[1];
                     String compareId = Common.user.getId();
                     if (myId.equals(userId)){

                            for (DataSnapshot list : snapshot.getChildren()) {

                                    ChattingModel mChatting = list.getValue(ChattingModel.class);
                                    boolean bIsSame = false;
                                    for (int i = 0; i < ChattingModels.size(); i++) {

                                        if (ChattingModels.get(i).getName() != null && mChatting.getName() != null && ChattingModels.get(i).getName().equals(mChatting.getName()) )
                                        {
                                            bIsSame = true;
                                            break;
                                        }
                                    }
                                    if (!bIsSame){
                                        if(!(mChatting.getName().equals(userName)))
                                            ChattingModels.add(mChatting);
                                    }


                            }
                     }
                }
//            reviewModel.setId(i);
//        